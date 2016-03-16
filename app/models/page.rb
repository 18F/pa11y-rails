class Page < ActiveRecord::Base
  belongs_to :site
  has_many :pa11y_issues, dependent: :destroy
  
  validates :title, presence: true,
                    length: { minimum: 1 }
  validates :url, presence: true,
                    length: { minimum: 3 }
  after_create :run_scan
  after_save :update_site_counts

  def update_site_counts
    Site.find(self.site_id).update_stats
  end

  def update_scan time=5000
    if Time.now - self.updated_at > time
      self.run_scan()
    end
  end

  def error_report
    %x(pa11y #{self.url} --reporter markdown --ignore "warning;notice")
  end

  def create_github_issue
    error_text = self.error_report
    github = Github.new user: '18F', repo: 'pa11y-rails'
    github.issues.create title: '508 Issue from pa11y-rails', body: self.error_report
  end

  def update_issue_count
    self.acc_errors   = 0
    self.acc_notices  = 0
    self.acc_warnings = 0
    self.acc_ignore   = 0
    self.acc_errors_fixed  = self.pa11y_fixed.count

    self.pa11y_issues.find_each do |issue|
      if issue.ignore
        self.increment(:acc_ignore, by = 1)
      elsif issue.fixed
        ''
      else
        case issue.issue_type
        when "error"
          self.increment(:acc_errors, by = 1)
        when "notice"
          self.increment(:acc_notices, by = 1)
        when "warning"
          self.increment(:acc_warnings, by = 1)
        end
      end
    end
    self.save
  end

  def run_scan
    puts self.url
    scan_url = "pa11y #{self.url} --reporter html"
    puts "Scan Url: #{scan_url}"
    self.scan = ''

    json_url = "pa11y #{self.url} --reporter json"
    json_string = %x(#{json_url})
    puts "Scan Complete!"


    # puts json_string
    
    # binding.pry
    # self.acc_errors = 0
    # self.acc_notices = 0
    # self.acc_warnings = 0
    puts "Parsing JSON"
    begin
      json_hash = JSON.parse(json_string)
      self.add_pa11y_issues(json_hash)
      self.update_issue_count()
    rescue JSON::ParserError => e
    end
    self.save
  end

  def add_pa11y_issues scan
    self.pa11y_issues.update_all({fixed: true})

     scan.each do |issue|
      pa11y_issue = self.pa11y_issues.where("css = ? AND code = ?", issue["selector"], issue["code"]).first
      if pa11y_issue
        pa11y_issue.update_attribute(:fixed, false)
      else
        self.pa11y_issues.create({
          description: issue["message"],
          code: issue["code"],
          css: issue["selector"], 
          element: issue["context"],
          issue_type: issue["type"],
          fixed: false,
          ignore: false
          })
      end
    end
  end

  def pa11y_errors
    puts 'Pa11y_errors'
    self.pa11y_issues.where(issue_type: "error").where(fixed: false)
  end

  def pa11y_warnings
    self.pa11y_issues.where(issue_type: "warning").where(fixed: false)
  end

  def pa11y_fixed
    self.pa11y_issues.where("fixed= 'true' AND issue_type= 'error'")
  end

  def issues_md
    md = "\n\n## Results for #{self.url}"
    self.pa11y_errors.where(ignore: false).each do |issue|
      md += "\n\n#{issue.markdown_description}"
    end
    md += "\n\n### Summary\n\n__Errors:__ #{self.acc_errors}"
    md
  end


end

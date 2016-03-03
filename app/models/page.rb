class Page < ActiveRecord::Base
  belongs_to :site
  has_many :pa11y_issues, dependent: :destroy
  
  validates :title, presence: true,
                    length: { minimum: 1 }
  validates :url, presence: true,
                    length: { minimum: 3 }
  after_create :run_scan

  def update_scan time=5000
    if Time.now - self.updated_at > time
      self.save
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
    self.acc_errors = 0;
    self.acc_notices = 0;
    self.acc_warnings = 0;
    self.pa11y_issues.find_each do |issue|
      unless issue.ignore
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
    # puts json_string
    
    # binding.pry
    self.acc_errors = 0
    self.acc_notices = 0
    self.acc_warnings = 0
    puts "Parsing JSON"
    begin
      json_hash = JSON.parse(json_string)
      puts "JSON Hash=: #{json_hash}"
      json_hash.each do |key, array|
        case key["type"]
        when "error"
          self.increment(:acc_errors, by = 1)
        when "notice"
          self.increment(:acc_notices, by = 1)
        when "warning"
          self.increment(:acc_warnings, by = 1)
        end
      end
      self.add_pa11y_issues(json_hash)
    rescue JSON::ParserError => e
    end
    self.save
  end

  def add_pa11y_issues scan
    
    scan.each do |issue|
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

  def pa11y_errors
    puts 'Pa11y_errors'
    self.pa11y_issues.where(issue_type: "error")
  end

  def pa11y_warnings
    self.pa11y_issues.where(issue_type: "warning")
  end

end

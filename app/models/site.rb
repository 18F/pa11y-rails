class Site < ActiveRecord::Base
  has_many :pages, dependent: :destroy
  has_many :issues, dependent: :destroy
  after_create :create_homepage
  after_save :find_github_issues
  before_save :update_pages_count

  def update_pages_count
    self.pages_count = self.pages.count
  end

  def update_stats
    self.update_acc_errors
    self.update_acc_errors_fixed
    self.update_acc_warnings
    self.update_page_count
    self.save
  end

  def update_page_count
    self.pages_count = self.pages.count 
  end

  def update_acc_errors
    errors = 0
    self.pages.each do |page|
      unless !page.acc_errors
        errors += page.acc_errors
      end
    end
    self.acc_errors = errors
  end

  def update_acc_errors_fixed
    fixed = 0
    self.pages.each do |page|
      unless page.acc_errors_fixed.nil?
        fixed += page.acc_errors_fixed
      end
    end
    self.acc_errors_fixed = fixed
  end

  def update_acc_warnings
    warnings = 0
    self.pages.each do |page|
      puts "#{page.title}"
      puts !page.acc_warnings
      unless !page.acc_warnings
        warnings += page.acc_warnings
      end
    end
    self.acc_warnings = warnings
  end

  def github_url
    if self.github_user && self.github_repo && !self.github_user.empty? && !self.github_repo.empty?
      "https://github.com/#{self.github_user}/#{self.github_repo}"
    else
      false
    end
  end

  def create_github_issue
    self.update_scan
    github = Github.new user: "#{self.github_user}", repo: "#{self.github_repo}"
    issue = github.issues.create title: '508 Issues from pa11y-rails', body: self.github_issue_string
    if issue.body.number
      self.issues.create({github_id: issue.body.number, title: "508 Issues from pa11y-rails"})
    end
    puts issue 
  end

  def github_issue_string
    github_string = "Results can be recreated using [HTML_CodeSniffer](http://squizlabs.github.io/HTML_CodeSniffer/)\n\n"
    self.pages.each do |page|
      github_string += page.issues_md
    end
    github_string
  end

  def update_scan
    @pages = self.pages
    @pages.each do |page|
      page.update_scan(0)
    end
    self.find_github_issues()
  end

  def github_scan
    @pages = self.pages
    scan = 'Results can be recreated using [HTML_CodeSniffer](http://squizlabs.github.io/HTML_CodeSniffer/)'
    @pages.each do |page|
      scan += page.error_report
    end
    scan = scan.gsub(/\# Welcome to Pa11y/,'')
    scan = scan.gsub(/\* 0 Warnings/,'')
    scan = scan.gsub(/\* 0 Notices/,'')
    scan
  end

  def github_status
    self.issues.length > 0 ? self.issues.last.status : ''
  end

  def find_github_issues
    if github_url
      issues = Github::Client::Issues.new
      list = issues.list user: self.github_user, repo: self.github_repo, state: 'open', auto_pagination: true
      list.each do |issue|
        if issue.is_a?(Hash) && issue.title && issue.number && issue.title.include?("508")
          self.issues.create_with({title:  issue.title})
                     .find_or_create_by(github_id: issue.number)
          # self.issues.create({github_id: issue.number, title: issue.title})
        end
      end
    end
  end

  def create_homepage
    github = Github.new
    repo = github.repos.find user: self.github_user, repo: self.github_repo
    homepage = repo.body["homepage"]
    if homepage && homepage.include?(".gov")
      self.pages.create_with({url: homepage}).find_or_create_by(title: homepage)
    end
  end
end

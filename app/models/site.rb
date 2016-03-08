class Site < ActiveRecord::Base
  has_many :pages, dependent: :destroy
  has_many :issues, dependent: :destroy
  after_save :find_github_issues

  def acc_errors
    errors = 0
    self.pages.find_each do |page|
      unless !page.acc_errors
        errors += page.acc_errors
      end
    end
    errors
  end

  def acc_warnings
    warnings = 0
    self.pages do |page|
      unless !page.acc_warnings
        warnings += page.acc_warnings
      end
    end
    warnings
  end

  def github_url
    if self.github_user && self.github_repo && !self.github_user.empty? && !self.github_repo.empty?
      "https://github.com/#{self.github_user}/#{self.github_repo}"
    else
      false
    end
  end

  # def create_github_issue
  #   github = Github.new user: "#{self.github_user}", repo: "#{self.github_repo}"
  #   issue = github.issues.create title: '508 Issues from pa11y-rails', body: self.github_scan
  #   if issue.body.number
  #     self.issues.create({github_id: issue.body.number})
  #   end
  #   puts issue 
  # end

  def create_github_issue
    github = Github.new user: "#{self.github_user}", repo: "#{self.github_repo}"
    issue = github.issues.create title: '508 Issues from pa11y-rails', body: self.github_issue_string
    if issue.body.number
      self.issues.create({github_id: issue.body.number})
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
    if self.issues.length > 0
      self.issues.last.status 
    else
      ''
    end
  end
  def find_github_issues
    if github_url
      issues = Github::Client::Issues.new
      list = issues.list user: self.github_user, repo: self.github_repo, state: 'open'
      list.each do |issue|
        if issue.is_a?(Hash) && issue.title && issue.number && issue.title == "508 Issues from pa11y-rails"
          self.issues.create({github_id: issue.number})
        end
      end
    end
  end
  def self.error_total
    total_errors = 0
    self.all.find_each do |site|
      total_errors += site.acc_errors
    end
    total_errors
  end
end

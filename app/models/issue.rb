class Issue < ActiveRecord::Base
  belongs_to :site
  def status
    if !self.github_id.nil?
      github = Github::Client::Issues.new
      issue = github.get self.site.github_user, self.site.github_repo, self.github_id
      issue.body.state
    else
      'N/A'
    end
  end
  def link
    "https://github.com/#{self.site.github_user}/#{self.site.github_repo}/issues/#{self.github_id}"
  end
end

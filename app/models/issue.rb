class Issue < ActiveRecord::Base
  belongs_to :site
  def status
    begin
      if !self.github_id.nil? && !self.site.github_user.nil? && !self.site.github_repo.nil?
        github = Github::Client::Issues.new
        issue = github.get self.site.github_user, self.site.github_repo, self.github_id
        issue.body.state
      else
        'N/A'
      end
    rescue Github::Error::GithubError => e
      puts e.message

      if e.is_a? Github::Error::ServiceError
        # handle GitHub service errors such as 404
      elsif e.is_a? Github::Error::ClientError
        # handle client errors e.i. missing required parameter in request
      end
    end
  end
  def link
    "https://github.com/#{self.site.github_user}/#{self.site.github_repo}/issues/#{self.github_id}"
  end
end

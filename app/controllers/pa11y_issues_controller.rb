class Pa11yIssuesController < ApplicationController
  def ignore
    @pa11y_issue = Pa11yIssue.find(params[:pa11y_issue_id])
    @pa11y_issue.update_attribute(:ignore, !@pa11y_issue.ignore);
    @pa11y_issue.page.update_issue_count()
    redirect_to site_path(params[:site_id])
  end
end

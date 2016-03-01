class IssuesController < ApplicationController
  def destroy
    @site = Site.find(params[:site_id])
    @issue = Issue.find(params[:id])
    @issue.destroy
   
    redirect_to site_path(@site)
  end

  def create
    @site = Site.find(params[:site_id])
    @issue = @site.issues.create(issue_params)
    redirect_to site_path(@site)
  end
  private
    def issue_params
        params.require(:issue).permit(:github_id)
    end
end

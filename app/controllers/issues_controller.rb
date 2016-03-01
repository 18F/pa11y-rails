class IssuesController < ApplicationController
  def destroy
    @site = Site.find(params[:site_id])
    @issue = Issue.find(params[:id])
    @issue.destroy
   
    redirect_to site_path(@site)
  end
end

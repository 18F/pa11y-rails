class PagesController < ApplicationController
  def create
    @site = Site.find(params[:site_id])
    @page = @site.pages.create(page_params)
    redirect_to site_path(@site)
  end
  def destroy
    @site = Site.find(params[:site_id])
    @page = Page.find(params[:id])
    @page.destroy
   
    redirect_to site_path(@site)
  end
 
  private
    def page_params
      params.require(:page).permit(:title, :url)
    end
end

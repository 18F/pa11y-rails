class SitesController < ApplicationController
  def show
    @site = Site.find(params[:id])
  end
  def index
    @sites = Site.all
  end

  def new
    @site = Site.new()
  end

  def create
    @site = Site.new(site_params)
 
    if @site.save
      redirect_to @site
    else
      render 'new'
    end
  end

  def destroy
    @site = Site.find(params[:id])
    @site.destroy
   
    redirect_to sites_path
  end

  def scanAll
    @sites = Site.all 
    update_scans(@sites)
    render 'index'
  end

  def error_report
    @site = Site.find(params[:site_id])
    render 'error'
  end

  private
    def site_params
      params.require(:site).permit(:title, :url)
    end
    def update_scans sites = Site.all
      sites.each do |site|
        site.update_scan(0)
      end
    end
end

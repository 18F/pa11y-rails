class SitesController < ApplicationController
  helper_method :sort_column, :sort_direction
  def show
    @site = Site.find(params[:id])
  end
  def index
    @sites = Site.order(sort_column + " " + sort_direction).paginate(:page => params[:page], :per_page => 10).includes(:pages, :issues)
  end

  def new
    @site = Site.new()
  end

  def edit
    @site = Site.find(params[:id])
  end

  def update
    @site = Site.find(params[:id])
    if @site.update(site_params)
      redirect_to @site
    else
      render 'edit'
    end
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
    redirect_to sites_path
  end

  def error_report
    @site = Site.find(params[:site_id])
    render 'error'
  end

  def create_github_issue
    @site = Site.find(params[:site_id])
    @site.create_github_issue()
    redirect_to site_path(@site)
  end
  def update_scan
    @site = Site.find(params[:site_id])
    @site.update_scan()
    redirect_to site_path(@site)
  end

  private
    def site_params
      params.require(:site).permit(:title, :url, :github_repo, :github_user)
    end

    def update_scans sites = Site.all
      sites.each do |site|
        site.update_scan
      end
    end

    def sort_column
      Site.column_names.include?(params[:sort]) ? params[:sort] : "acc_errors"
    end
    
    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
    end
end

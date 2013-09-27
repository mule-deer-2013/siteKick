class PagesController < ApplicationController

  def new
    @page = Page.new
  end

  def create
    @page = Page.create(params[:page])
    @page.get_content
    @page.save
    redirect_to page_path(@page)
  end

  def show
    @page = Page.find(params[:id])
    @page.title
  end

  def index
  end

end

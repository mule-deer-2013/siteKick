class PagesController < ApplicationController

  def new
    @page = Page.new
  end

  def create
    @page = Page.create(params[:page])

    redirect_to page_path(@page)
  end

  def show
    @page = Page.find(params[:id])
    @page.title
  end

  def index
  end

end

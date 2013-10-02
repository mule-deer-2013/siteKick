class PagesController < ApplicationController

  def new
    @page = Page.new
    render 'pages/new', layout: false
  end

  def create
    p params
    @page = Page.create(params[:page])
    p params
    PageTest.create(page_id: @page.id)
    p 'something'
    redirect_to page_path(@page)
  end

  def show
    @page = Page.find(params[:id])
    @test = PageTest.where(page_id: @page.id).last
    @page.title
  end

end

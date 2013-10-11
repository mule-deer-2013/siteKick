class PagesController < ApplicationController

  def new
    @page = Page.new
  end

  def create
    @page = Page.create(original_url: params[:original_url], user_id: current_user.id)
    PageTest.create(page_id: @page.id)
    redirect_to page_path(@page)
  end

  def show
    @page = Page.find(params[:id])
    @test = PageTest.where(page_id: @page.id).last
    @page.title
  end



end

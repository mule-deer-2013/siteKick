class TestsController < ApplicationController

  def create
    @test = Test.new(page: @page)
    @test.run_test_suite
    @test.save
  end

end
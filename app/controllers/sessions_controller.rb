class SessionsController < ApplicationController
  
  def create
    debugger
    puts "*"*80
    puts params
    auth = request.env["omniauth.auth"]
    user = User.find_by_provider_and_uid(auth["provider"], auth["uid"]) || User.create_with_omniauth(auth)
    session[:user_id] = user.id
    redirect_to new_page_path, :notice => "Signed in!"
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => "Signed out!"
  end

  def failure
    redirect_to root_url, :notice => "You denied authentication."
  end

end

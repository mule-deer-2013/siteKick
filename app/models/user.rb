class User < ActiveRecord::Base

  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.oauth_token = auth.credentials.token
      user.oauth_token_secret = auth.credentials.secret
    end
  end
  
  def tumblr_client
    @client ||= Tumblr::Client.new(
      consumer_key: ENV['TUMBLR_KEY'],
      consumer_secret: ENV['TUMBLR_SECRET'],
      oauth_token: self.oauth_token,
      oauth_token_secret: self.oauth_token_secret
    )
  end

end

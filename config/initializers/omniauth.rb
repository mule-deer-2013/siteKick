unless Rails.env.production?
  require 'dotenv'
  Dotenv.load
end

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :tumblr, ENV['TUMBLR_KEY'], ENV['TUMBLR_SECRET']
end
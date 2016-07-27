Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, ENV['twitter_consumer_key'], ENV['twitter_consumer_secret']
end

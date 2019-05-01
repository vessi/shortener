UrlShortener::Config.configure do |config|
  config.storage_engine = UrlShortener::RedisStore
end

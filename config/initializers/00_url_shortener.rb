# frozen_string_literal: true

UrlShortener.configure do |config|
  config.storage_engine = UrlShortener::RedisStore
end

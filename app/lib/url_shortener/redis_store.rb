# frozen_string_literal: true

module UrlShortener
  class RedisStore
    def initialize
      @client = Redis.new
    end

    def store(key, value)
      @client.set(key.to_s, value.to_s) == 'OK'
    end

    def fetch(key)
      @client.get(key)
    end
  end
end

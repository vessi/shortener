module UrlShortener
  module Config
    extend self
    attr_accessor :storage_engine, :storage
    attr_reader :storage

    def configure
      yield self
      @storage = storage_engine.new
    end
  end
end

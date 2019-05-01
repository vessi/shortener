# frozen_string_literal: true

module UrlShortener
  class Config
    attr_reader :storage_engine
    attr_accessor :storage

    def storage_engine=(value)
      @storage_engine = value
      self.storage = storage_engine.new
    end
  end
end

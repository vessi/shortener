module UrlShortener
  class Config
    attr_accessor :storage_engine, :storage

    def storage_engine=(value)
      @storage_engine = value
      self.storage = storage_engine.new
    end

  end
end

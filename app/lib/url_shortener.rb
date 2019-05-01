require 'addressable'

module UrlShortener
  PARSE_URL = -> (url) { Addressable::URI.heuristic_parse(url) }
  DOWNCASE_HOST = -> (parsed) { parsed.host = parsed.host.downcase; parsed }
  STRINGIFY_HOST = -> (parsed) { parsed.to_s }
  CRC32_URL = -> (url) { Digest::CRC32.hexdigest(url) }

  PREPROCESSORS = [
    PARSE_URL,
    DOWNCASE_HOST,
    STRINGIFY_HOST,
    CRC32_URL
  ]

  class << self

    attr_accessor :configuration

    def configure
      self.configuration ||= UrlShortener::Config.new
      yield(configuration)
    end

    def store(url:, base_host:)
      shorten_url = PREPROCESSORS.inject(&:>>).call(url)
      configuration.storage.store(shorten_url, url)
      base_host + shorten_url
    end

    def fetch(shorten_url:)
      value = configuration.storage.fetch(shorten_url)
      raise UrlShortener::NotFoundError unless value.present?

      value
    end
  end
end

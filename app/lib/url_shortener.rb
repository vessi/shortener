module UrlShortener
  class << self
    SANITIZE_URL = -> (url) { url }
    DOWNCASE_URL_HOST = -> (url) { url }
    CRC32_URL = -> (url) { Digest::CRC32.hexdigest(url) }

    PREPROCESSORS = [
      SANITIZE_URL,
      DOWNCASE_URL_HOST,
      CRC32_URL
    ]

    def store(url:)
      shorten_url = PREPROCESSORS.inject(&:<<).call(url)
      UrlShortener::Config.storage.store(shorten_url, url)
      shorten_url
    end

    def fetch(shorten_url:)
      value = UrlShortener::Config.storage.fetch(shorten_url)
      raise UrlShortener::NotFoundError unless value.present?

      value
    end
  end
end

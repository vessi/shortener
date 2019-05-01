require 'rails_helper'

RSpec.describe UrlShortener do
  context 'preprocessors' do
    it 'parses URL' do
      expect(described_class::PARSE_URL.call('google.com')).to be_an(Addressable::URI)
    end

    it 'suggests schema' do
      url = Addressable::URI.heuristic_parse('www.google.com')
      expect(described_class::DOWNCASE_HOST.call(url).scheme).to eq('http')
    end

    it 'downcases host' do
      url = Addressable::URI.heuristic_parse('http://WWW.GOOGLE.COM')
      expect(described_class::DOWNCASE_HOST.call(url).host).to eq('www.google.com')
    end

    it 'stringifies host' do
      url = Addressable::URI.heuristic_parse('http://www.google.com')
      expect(described_class::STRINGIFY_HOST.call(url)).to eq('http://www.google.com')
    end

    it 'takes crc32 from string' do
      expect(described_class::CRC32_URL.call('http://www.google.com')).to eq('5ea077a5')
    end
  end

  context '#configure' do
    it 'instantiates store' do
      storage_stub = class_double("Store")
      expect(storage_stub).to receive(:new)

      described_class.configure do |config|
        config.storage_engine = storage_stub
      end
    end

    it 'stores configuration' do
      storage_stub = class_double("Store")
      storage = double(:storage)
      allow(storage_stub).to receive(:new).and_return(storage)
      described_class.configure do |config|
        config.storage_engine = storage_stub
      end

      expect(described_class.configuration.storage).to eq(storage)
    end
  end

  context '#store' do
    let(:storage) { double(:storage) }
    let(:configuration) { double(:configuration) }

    before(:each) do
      configuration.stub(:storage) { storage }
      allow(described_class).to receive(:configuration).and_return(configuration)
    end

    it 'applies all preprocessors' do
      expect(storage).to receive(:store).with('5ea077a5', 'http://www.google.com')
      described_class.store(url: 'http://www.google.com', base_host:'')
    end

    it 'adds base url' do
      allow(storage).to receive(:store)
      shortened = described_class.store(url: 'http://www.google.com', base_host: 'http://localhost/')
      expect(shortened).to eq('http://localhost/5ea077a5')
    end
  end

  context '#fetch' do
    let(:storage) { double(:storage) }
    let(:configuration) { double(:configuration) }

    before(:each) do
      configuration.stub(:storage) { storage }
      allow(described_class).to receive(:configuration).and_return(configuration)
    end

    it 'gets value from storage by short url' do
      allow(storage).to receive(:fetch).with('5ea077a5').and_return('http://www.google.com')
      full = described_class.fetch(shorten_url: '5ea077a5')
      expect(full).to eq('http://www.google.com')
    end

    it 'raises error if value is not present' do
      allow(storage).to receive(:fetch).and_return(nil)
      expect { described_class.fetch(shorten_url: '5ea077a5') }.to raise_error(UrlShortener::NotFoundError)
    end
  end
end

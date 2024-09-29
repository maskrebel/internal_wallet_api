require 'net/http'
require 'json'

module LatestStockPrice
  API_HOST = "https://latest-stock-price.p.rapidapi.com"
  HEADERS = {
    "x-rapidapi-host" => "latest-stock-price.p.rapidapi.com",
    "x-rapidapi-key" => ENV['RAPIDAPI_KEY']
  }

  class Client
    def self.price(ticker)
      request("any?Identifier=#{ticker}")
    end

    def self.prices(tickers)
      request("any?Identifier=#{tickers}")
    end

    def self.price_all
      request("any")
    end

    private

    def self.request(endpoint)
      uri = URI("#{API_HOST}/#{endpoint}")
      response = Net::HTTP.get(uri, HEADERS)
      JSON.parse(response)
    end
  end
end

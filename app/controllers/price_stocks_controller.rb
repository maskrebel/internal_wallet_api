class PriceStocksController < ApplicationController
  def show
    ticker = params[:ticker]

    begin
      stock_price = LatestStockPrice::Client.price(ticker)
      render json: { ticker: ticker, price: stock_price }, status: :ok and return
    rescue => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end

  def index
    tickers = params[:tickers]&.split(',')
    if tickers.present?
      begin
        prices = LatestStockPrice::Client.prices(params[:tickers])
        render json: { tickers: tickers, prices: prices }, status: :ok
      rescue => e
        render json: { error: e.message }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Tickers parameter is required' }, status: :bad_request
    end
  end

  def all
    begin
      all_prices = LatestStockPrice::Client.price_all
      render json: all_prices, status: :ok
    rescue => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end
end

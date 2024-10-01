require "test_helper"

class StocksControllerTest < ActionDispatch::IntegrationTest
  let(:ticker) { 'AAPL' }
  let(:tickers) { 'AAPL,GOOGL' }

  describe 'GET #show' do
    context 'when the ticker is valid' do
      before do
        allow(LatestStockPrice::Client).to receive(:price).with(ticker).and_return(150.00)
        get :show, params: { ticker: ticker }
      end
    end
  end
end

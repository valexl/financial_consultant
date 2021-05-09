require 'spec_helper'

RSpec.describe FinancialConsultant::Investments::API, roda: :app do
  let(:headers) { { "ACCEPT" => "application/json" } }

  before do
    Repositories::BalanceRepository.initiate
  end

  describe 'GET /balance.json' do
    let(:expected_response) do
      {
        "cash" => {
          "rub" => 0.0,
          "usd" => 0.0,
          "eur" => 0.0,
        },
        "investments" => []
      }
    end
    let(:balance) { Repositories::BalanceRepository.fetch }

    before { get '/balance', headers: headers }

    it { is_expected.to be_successful }
    it { expect(response_body).to eq(expected_response) }
  end

  describe 'POST /balance/replenish.json' do
    before { post '/balance/replenish', params: params, headers: headers }
    let(:params) do
      {
        currency: "USD",
        value: 1000
      }
    end

    it { is_expected.to be_successful }
  end

  def response_body
    JSON.parse(last_response.body)
  end
end

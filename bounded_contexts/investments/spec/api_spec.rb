require 'spec_helper'

RSpec.describe FinancialConsultant::Investments::API, roda: :app do
  let(:headers) { { "ACCEPT" => "application/json" } }

  before do
    Repositories::BalanceRepository.initiate
  end

  describe 'GET /balance.json' do
    let(:get_balance) do 
      Proc.new { get '/balance', headers: headers }
    end
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

    before { get_balance.call }

    it { is_expected.to be_successful }
    it { expect(response_body).to eq(expected_response) }
  end

  describe 'POST /balance/replenish.json' do
    let(:post_repleninsh_balance) do
      Proc.new {  post '/balance/replenish', params.merge(headers: headers) }
    end
    let(:params) do
      {
        money: {
          currency: "USD",
          value: 1000
        }
      }
    end
    let(:expected_response) do
      {
        "cash" => {
          "rub" => 0.0,
          "usd" => 1000.0,
          "eur" => 0.0,
        },
        "investments" => []
      }
    end

    it "returns expected response" do
      post_repleninsh_balance.call
      expect(response_body).to eq(expected_response)
    end

    it "increases USD cach value on balance" do
      expect {
        post_repleninsh_balance.call
      }.to change { Repositories::BalanceRepository.fetch.usd_cash_only_value }
      .and avoid_changing { Repositories::BalanceRepository.fetch.rub_cash_only_value }
      .and avoid_changing { Repositories::BalanceRepository.fetch.eur_cash_only_value }
    end
  end

  def response_body
    JSON.parse(last_response.body)
  end
end

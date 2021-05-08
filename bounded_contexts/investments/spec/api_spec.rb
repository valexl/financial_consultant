require 'spec_helper'

RSpec.describe FinancialConsultant::Investments::API, roda: :app do
  let(:headers) do
    { "ACCEPT" => "application/json" }
  end

  describe 'GET /balance.json' do
    before { get '/balance', headers: headers }

    it { is_expected.to be_successful }
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
end

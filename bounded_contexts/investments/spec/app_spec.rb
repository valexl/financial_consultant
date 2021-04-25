require "spec_helper"

RSpec.describe FinancialConsultant::Investments::App, roda: :app do
  describe "GET /" do
    before { get '/' }

    it do
      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_request.path).to eql '/balance'
    end
  end

  describe "GET /balance/replenish" do
    before { get 'balance/replenish' }
    
    it { is_expected.to be_successful }
  end

  context "investments" do
    describe 'GET /investments/open' do
      before { get '/investments/open' }

      it { is_expected.to be_successful }
    end

    describe 'GET /investments/:investment_id/edit' do
      let(:investment_id)  { 1 }
      before { get "/investments/#{investment_id}/edit" }

      it { is_expected.to be_successful }
    end

    describe 'GET /investments/:investment_id/close' do
      let(:investment_id)  { 1 }
      before { get "/investments/#{investment_id}/close" }

      it { is_expected.to be_successful }
    end
  end
end
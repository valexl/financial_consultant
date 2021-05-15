require 'spec_helper'

RSpec.describe FinancialConsultant::Investments::API, roda: :app do
  let(:headers) { { "ACCEPT" => "application/json" } }
  let(:builder)  { MoneyBuilder.new }
  let(:money_creator) { MoneyCreator.new(builder) }
  let(:balance) do
    cash = Cash.new(
      rub_money: money_creator.build_rub(value: initial_balance_rub_value),
      usd_money: money_creator.build_usd(value: initial_balance_usd_value),
      eur_money: money_creator.build_eur(value: initial_balance_eur_value)
    )
    Balance.new(cash: cash, investments: [])
  end
  let(:initial_balance_rub_value) { 0 }
  let(:initial_balance_usd_value) { 0 }
  let(:initial_balance_eur_value) { 0 }

  before do
    Repositories::BalanceRepository.create(balance)
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
        "total_equity" => {
          "rub" => 0.0,
          "usd" => 0.0,
          "eur" => 0.0,
        },
        "investments" => []
      }
    end
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
        "total_equity" => {
          "rub" => 75000.0,
          "usd" => 1000.0,
          "eur" => 800,
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

  describe 'POST /investments/open.json' do
    let(:post_open_investment) do
      Proc.new {  post '/investments/open', params.merge(headers: headers) }
    end

    let(:initial_balance_rub_value) { 100000 }
    let(:initial_balance_usd_value) { 3000 }
    let(:initial_balance_eur_value) { 700 }
    let(:params) do
      {
        investment: {
          type: investment_type,
          name: "Test",
          price: {
            currency: "USD",
            value: 1000
          }
        }
      }
    end

    before do
      Repositories::BalanceRepository.save(balance)
    end

    context "when investment type is apartment" do
      let(:investment_type) { "apartment" }
  
      let(:expected_response) do
        {
          "investment" => {
            "type" => "apartment",
            "name"=>"Test",
            "price" => {
              "currency" => "USD",
              "value" => 1000
            }
          },
        }
      end
  
      it "returns expected response" do
        post_open_investment.call
        expect(response_body).to eq(expected_response)
      end

      it "increases number of investments on balakce" do
        expect {
          post_open_investment.call
        }.to change { Repositories::BalanceRepository.fetch.investments.count }
        .and avoid_changing { Repositories::BalanceRepository.fetch.rub_cash_only_value }
        .and change { Repositories::BalanceRepository.fetch.usd_cash_only_value }.from(3000).to(2000)
        .and avoid_changing { Repositories::BalanceRepository.fetch.eur_cash_only_value }
      end
    end
    
    context "when investment type is stock" do
      let(:investment_type) { "stock" }
  
      let(:expected_response) do
        {
          "investment" => {
            "type" => "stock",
            "name"=>"Test",
            "price" => {
              "currency" => "USD",
              "value" => 1000
            }
          },
        }
      end
  
      it "returns expected response" do
        post_open_investment.call
        expect(response_body).to eq(expected_response)
      end

      it "increases number of investments on balakce" do
        expect {
          post_open_investment.call
        }.to change { Repositories::BalanceRepository.fetch.investments.count }
        .and avoid_changing { Repositories::BalanceRepository.fetch.rub_cash_only_value }
        .and change { Repositories::BalanceRepository.fetch.usd_cash_only_value }.from(3000).to(2000)
        .and avoid_changing { Repositories::BalanceRepository.fetch.eur_cash_only_value }
      end
    end
  end

  describe 'POST /investments/close.json' do
    let(:initial_balance_rub_value) { 100000 }
    let(:initial_balance_usd_value) { 3000 }
    let(:initial_balance_eur_value) { 700 }
    let(:post_open_investment) do
      Proc.new {  post '/investments/close', params.merge(headers: headers) }
    end
    let(:params) do
      {
        investment: {
          name: investment_name
        }
      }
    end
    let(:investment_name) { "test_investment" }
    let(:investment_price) do
      money_creator.build(
        currency: "USD", 
        value: 1000
      )
    end


    context "when close apartment investment" do
      let(:expected_response) do
        {
          "investment" => {
            "type" => "apartment",
            "name"=>investment_name,
            "price" => {
              "currency" => "USD",
              "value" => 1000
            }
          },
        }
      end

      before do
        balance.open_apartment_investment(
            name: investment_name, 
            price: investment_price
          )
        Repositories::BalanceRepository.save(balance)
      end

      it "returns expected response" do
        post_open_investment.call
        expect(response_body).to eq(expected_response)
      end
    end

    context "when close stock investment" do
      let(:expected_response) do
        {
          "investment" => {
            "type" => "stock",
            "name"=>investment_name,
            "price" => {
              "currency" => "USD",
              "value" => 1000
            }
          },
        }
      end

      before do
        balance.open_stock_investment(
            name: investment_name, 
            price: investment_price
          )
        Repositories::BalanceRepository.save(balance)
      end

      it "returns expected response" do
        post_open_investment.call
        expect(response_body).to eq(expected_response)
      end
    end

  end

  def response_body
    JSON.parse(last_response.body)
  end
end

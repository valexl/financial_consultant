require 'spec_helper'

RSpec.describe FinancialConsultant::Investments::API, roda: :app do
  let(:headers) { { "ACCEPT" => "application/json" } }
  let(:money_creator) { MoneyCreator.new }
  let(:balance) do
    cash = Cash.new(
      rub_money: money_creator.build_rub(value: balance_rub_value),
      usd_money: money_creator.build_usd(value: balance_usd_value),
      eur_money: money_creator.build_eur(value: balance_eur_value)
    )
    Balance.new(cash: cash, investments: [])
  end
  let(:balance_rub_value) { 0 }
  let(:balance_usd_value) { 0 }
  let(:balance_eur_value) { 0 }

  before do
    Repositories::BalanceRepository.create(balance)
  end

  describe 'GET /balance.json' do
    let(:get_balance) do 
      Proc.new { get '/balance', headers: headers }
    end
    let(:expected_response) do
      {
        "balance" => {
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
        "balance" => {
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
      }
    end

    it "returns expected response" do
      post_repleninsh_balance.call
      expect(response_body).to eq(expected_response)
    end

    it "increases USD cach value on balance" do
      expect {
        post_repleninsh_balance.call
      }.to change { Repositories::BalanceRepository.fetch.cash_usd_money_value }
      .and avoid_changing { Repositories::BalanceRepository.fetch.cash_rub_money_value }
      .and avoid_changing { Repositories::BalanceRepository.fetch.cash_eur_money_value }
    end
  end

  describe 'POST /investments/open.json' do
    let(:post_open_investment) do
      Proc.new {  post '/investments/open', params.merge(headers: headers) }
    end

    let(:balance_rub_value) { 100000 }
    let(:balance_usd_value) { 3000 }
    let(:balance_eur_value) { 700 }
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
            "status" => "opened",
            "price" => {
              "currency" => "USD",
              "value" => 1000
            },
            "invested_money" => {
              "currency" => "USD",
              "initial_value" => 1000,
              "income" => 0,
              "income_of_income" => 0,
              "income_of_income_of_income" => 0,
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
        .and avoid_changing { Repositories::BalanceRepository.fetch.cash_rub_money_value }
        .and change { Repositories::BalanceRepository.fetch.cash_usd_money_value }.from(3000).to(2000)
        .and avoid_changing { Repositories::BalanceRepository.fetch.cash_eur_money_value }
      end
    end
    
    context "when investment type is stock" do
      let(:investment_type) { "stock" }
  
      let(:expected_response) do
        {
          "investment" => {
            "type" => "stock",
            "name"=>"Test",
            "status" => "opened",
            "price" => {
              "currency" => "USD",
              "value" => 1000
            },
            "invested_money" => {
              "currency" => "USD",
              "initial_value" => 1000,
              "income" => 0,
              "income_of_income" => 0,
              "income_of_income_of_income" => 0,
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
        .and avoid_changing { Repositories::BalanceRepository.fetch.cash_rub_money_value }
        .and change { Repositories::BalanceRepository.fetch.cash_usd_money_value }.from(3000).to(2000)
        .and avoid_changing { Repositories::BalanceRepository.fetch.cash_eur_money_value }
      end
    end
  end

  describe 'POST /investments/close.json' do
    let(:balance_rub_value) { 100000 }
    let(:balance_usd_value) { 3000 }
    let(:balance_eur_value) { 700 }
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
      Investments::Price.new(
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
            "status" => "closed",
            "price" => {
              "currency" => "USD",
              "value" => 1000
            },
            "invested_money" => {
              "currency" => "USD",
              "initial_value" => 1000,
              "income" => 0,
              "income_of_income" => 0,
              "income_of_income_of_income" => 0,
            }
          },
        }
      end

      before do
        open_apartment_investment(balance, investment_name, investment_price)
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
            "status" => "closed",
            "price" => {
              "currency" => "USD",
              "value" => 1000
            },
            "invested_money" => {
              "currency" => "USD",
              "initial_value" => 1000,
              "income" => 0,
              "income_of_income" => 0,
              "income_of_income_of_income" => 0,
            }
          },
        }
      end

      before do
        open_stock_investment(balance, investment_name, investment_price)
        Repositories::BalanceRepository.save(balance)
      end

      it "returns expected response" do
        post_open_investment.call
        expect(response_body).to eq(expected_response)
      end
    end
  end

  describe 'POST /investments/dividend.json' do
    let(:receive_investment_dividend) do
      Proc.new {  post '/investments/dividend', params.merge(headers: headers) }
    end
    let(:params) do
      {
        investment: {
          name: investment_name
        },
        dividend: {
          currency: dividend_currency,
          value: dividend_value
        }
      }
    end
    let(:balance_rub_value) { 0 }
    let(:balance_usd_value) { 100000 }
    let(:balance_eur_value) { 0 }
    let(:investment_name) { "test_investment" }
    let(:dividend_currency) { "USD"}
    let(:dividend_value) { 1000 }
    let(:investment_price) do
      Investments::Price.new(
        currency: "USD", 
        value: 100000
      )
    end

    let(:expected_response) do
        {
          "investment" => {
            "type" => "apartment",
            "name"=>investment_name,
            "status" => "opened",
            "price" => {
              "currency" => dividend_currency,
              "value" => 100000
            },
            "invested_money" => {
              "currency" => "USD",
              "initial_value" => balance_usd_value - dividend_value,
              "income" => 0,
              "income_of_income" => 0,
              "income_of_income_of_income" => 0,
            }
          },
        }
      end    

    before do
      open_apartment_investment(balance, investment_name, investment_price)
      Repositories::BalanceRepository.save(balance)
    end

    it "returns expected response" do
      receive_investment_dividend.call
      expect(response_body).to eq(expected_response)
    end

    context "when investment was closed" do
      let(:expected_response) do
        {
          "status" => "skipped"
        }
      end

      before do
        investment = balance.find_investment(name: investment_name)
        investment.close
        Repositories::BalanceRepository.save(balance)
      end

      it "returns expected response" do
        receive_investment_dividend.call
        expect(response_body).to eq(expected_response)
      end
    end
  end

  describe 'POST /investments/expense.json' do
    let(:receive_investment_expense) do
      Proc.new {  post '/investments/expense', params.merge(headers: headers) }
    end
    let(:params) do
      {
        investment: {
          name: investment_name
        },
        expense: {
          currency: expense_currency,
          value: expense_value
        }
      }
    end
    let(:balance_rub_value) { 0 }
    let(:balance_usd_value) { 110000 }
    let(:balance_eur_value) { 0 }
    let(:investment_name) { "test_investment" }
    let(:expense_currency) { "USD"}
    let(:expense_value) { 1000 }
    let(:investment_price) do
      Investments::Price.new(
        currency: "USD", 
        value: 100000
      )
    end

    let(:expected_response) do
        {
          "investment" => {
            "type" => "apartment",
            "name"=>investment_name,
            "status" => "opened",
            "price" => {
              "currency" => expense_currency,
              "value" => 100000
            },
            "invested_money" => {
              "currency" => "USD",
              "initial_value" => investment_price.value + expense_value,
              "income" => 0,
              "income_of_income" => 0,
              "income_of_income_of_income" => 0,
            }
          },
        }
      end    

    before do
      open_apartment_investment(balance, investment_name, investment_price)
      Repositories::BalanceRepository.save(balance)
    end

    it "returns expected response" do
      receive_investment_expense.call
      expect(response_body).to eq(expected_response)
    end

    context "when investment was closed" do
      let(:expected_response) do
        {
          "status" => "skipped"
        }
      end

      before do
        investment = balance.find_investment(name: investment_name)
        investment.close
        Repositories::BalanceRepository.save(balance)
      end

      it "returns expected response" do
        receive_investment_expense.call
        expect(response_body).to eq(expected_response)
      end
    end
  end

  def response_body
    JSON.parse(last_response.body)
  end

  def open_apartment_investment(balance, investment_name, investment_price)
    Investments::ApartmentInvestment.new(
      balance: balance,
      name: investment_name,
      price: investment_price
    ).open
  end

  def open_stock_investment(balance, investment_name, investment_price)
    Investments::StockInvestment.new(
      balance: balance,
      name: investment_name,
      price: investment_price
    ).open
  end
end

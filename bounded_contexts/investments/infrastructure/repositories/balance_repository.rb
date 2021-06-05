module Repositories
  class BalanceRepository
    def self.create(balance)
      cash = {
        "rub" =>  {
          "value" => balance.rub_cash_money.value,
          "income" => balance.rub_cash_money.income,
          "income_of_income" => balance.rub_cash_money.income_of_income,
          "income_of_income_of_income" => balance.rub_cash_money.income_of_income_of_income,
        },
        "usd" =>  {
          "value" => balance.usd_cash_money.value,
          "income" => balance.usd_cash_money.income,
          "income_of_income" => balance.usd_cash_money.income_of_income,
          "income_of_income_of_income" => balance.usd_cash_money.income_of_income_of_income,
        },
        "eur" =>  {
          "value" => balance.eur_cash_money.value,
          "income" => balance.eur_cash_money.income,
          "income_of_income" => balance.eur_cash_money.income_of_income,
          "income_of_income_of_income" => balance.eur_cash_money.income_of_income_of_income,
        },
      }      
      investments = balance.investments.map do |investment|
        investment_record(investment)
      end

      balance_record = BalanceRecord.create(
        cash: cash.to_json,
        investments: investments.to_json
      )
      balance.id = balance_record.id
    end

    def self.fetch
      balace_record = BalanceRecord.last
      cash_data = JSON.parse(balace_record.cash)
      # TODO: investments_data should be converted to array of Investment::*
      investments_data = JSON.parse(balace_record.investments)

      builder = MoneyBuilder.new
      money_creator = MoneyCreator.new(builder)

      cash = Cash.new(
        rub_money: money_creator.build_rub(value: cash_data.dig("rub", "value").to_f, income: cash_data.dig("rub", "income"), income_of_income: cash_data.dig("rub", "income_of_income"), income_of_income_of_income: cash_data.dig("rub", "income_of_income_of_income")),
        usd_money: money_creator.build_usd(value: cash_data.dig("usd", "value").to_f, income: cash_data.dig("usd", "income"), income_of_income: cash_data.dig("usd", "income_of_income"), income_of_income_of_income: cash_data.dig("usd", "income_of_income_of_income")),
        eur_money: money_creator.build_eur(value: cash_data.dig("eur", "value").to_f, income: cash_data.dig("eur", "income"), income_of_income: cash_data.dig("eur", "income_of_income"), income_of_income_of_income: cash_data.dig("eur", "income_of_income_of_income"))
      )

      balance = Balance.new(id: balace_record.id, cash: cash)
      balance.investments = investments_data.map do |investment|
        klass = investment["type"] == "apartment" ? Investments::ApartmentInvestment : Investments::StockInvestment
        initial_price = money_creator.build(currency: investment.dig("initial_price","currency"), value: investment.dig("initial_price", "value"), income: investment.dig("initial_price", "income"), income_of_income: investment.dig("initial_price", "income_of_income"), income_of_income_of_income: investment.dig("initial_price", "income_of_income_of_income"))
        price = money_creator.build(currency: investment.dig("price","currency"), value: investment.dig("price", "value"), income: investment.dig("price", "income"), income_of_income: investment.dig("price", "income_of_income"), income_of_income_of_income: investment.dig("price", "income_of_income_of_income"))
        total_costs = money_creator.build(currency: investment.dig("total_costs","currency"), value: investment.dig("total_costs", "value"), income: investment.dig("total_costs", "income"), income_of_income: investment.dig("total_costs", "income_of_income"), income_of_income_of_income: investment.dig("total_costs", "income_of_income_of_income"))
        total_earnings = money_creator.build(currency: investment.dig("total_earnings","currency"), value: investment.dig("total_earnings", "value"), income: investment.dig("total_earnings", "income"), income_of_income: investment.dig("total_earnings", "income_of_income"), income_of_income_of_income: investment.dig("total_earnings", "income_of_income_of_income"))
        klass.new(name: investment["name"], initial_price: initial_price, price: price, total_costs: total_costs, total_earnings: total_earnings, balance: balance, status: investment["status"])
      end
      balance
    end

    def self.save(balance)
      cash = {
        "rub" =>  {
          "value" => balance.rub_cash_money.value,
          "income" => balance.rub_cash_money.income,
          "income_of_income" => balance.rub_cash_money.income_of_income,
          "income_of_income_of_income" => balance.rub_cash_money.income_of_income_of_income,
        },
        "usd" =>  {
          "value" => balance.usd_cash_money.value,
          "income" => balance.usd_cash_money.income,
          "income_of_income" => balance.usd_cash_money.income_of_income,
          "income_of_income_of_income" => balance.usd_cash_money.income_of_income_of_income,
        },
        "eur" =>  {
          "value" => balance.eur_cash_money.value,
          "income" => balance.eur_cash_money.income,
          "income_of_income" => balance.eur_cash_money.income_of_income,
          "income_of_income_of_income" => balance.eur_cash_money.income_of_income_of_income,
        },
      }
      investments = balance.investments.map do |investment|
        investment_record(investment)
      end
      BalanceRecord.where(id: balance.id).update(cash: cash.to_json, investments: investments.to_json)
    end

    private

    def self.investment_record(investment)
      {
          "type" => investment.type,
          "name" => investment.name,
          "status" => investment.status,
          "initial_price" => {
            "currency" => investment.initial_price_currency,
            "value" => investment.initial_price_value,
            "income" => investment.initial_price_income,
            "income_of_income" => investment.initial_price_income_of_income,
            "income_of_income_of_income" => investment.initial_price_income_of_income_of_income,
          },
          "price" => {
            "currency" => investment.price_currency,
            "value" => investment.price_value,
            "income" => investment.price_income,
            "income_of_income" => investment.price_income_of_income,
            "income_of_income_of_income" => investment.price_income_of_income_of_income,
          },
          "total_costs" => {
            "currency" => investment.total_costs_currency,
            "value" => investment.total_costs_value,
            "income" => investment.total_costs_income,
            "income_of_income" => investment.total_costs_income_of_income,
            "income_of_income_of_income" => investment.total_costs_income_of_income_of_income,
          },
          "total_earnings" => {
            "currency" => investment.total_earnings_currency,
            "value" => investment.total_earnings_value,
            "income" => investment.total_earnings_income,
            "income_of_income" => investment.total_earnings_income_of_income,
            "income_of_income_of_income" => investment.total_earnings_income_of_income_of_income,
          }
        }
    end

    def self.balance_table
      DB[:balances]
    end

    class BalanceRecord <  Sequel::Model(:balances)
    end


  end
end
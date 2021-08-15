module Repositories
  class BalanceRepository
    def self.create(balance)
      cash = {
        "rub" =>  {
          "value" => balance.cash_rub_money.value,
          "initial_value_in_percent" => balance.cash_rub_money.initial_value_in_percent,
          "income_in_percent" => balance.cash_rub_money.income_in_percent,
          "income_of_income_in_percent" => balance.cash_rub_money.income_of_income_in_percent,
          "income_of_income_of_income_in_percent" => balance.cash_rub_money.income_of_income_of_income_in_percent,
        },
        "usd" =>  {
          "value" => balance.cash_usd_money.value,
          "initial_value_in_percent" => balance.cash_usd_money.initial_value_in_percent,
          "income_in_percent" => balance.cash_usd_money.income_in_percent,
          "income_of_income_in_percent" => balance.cash_usd_money.income_of_income_in_percent,
          "income_of_income_of_income_in_percent" => balance.cash_usd_money.income_of_income_of_income_in_percent,
        },
        "eur" =>  {
          "value" => balance.cash_eur_money.value,
          "initial_value_in_percent" => balance.cash_eur_money.initial_value_in_percent,
          "income_in_percent" => balance.cash_eur_money.income_in_percent,
          "income_of_income_in_percent" => balance.cash_eur_money.income_of_income_in_percent,
          "income_of_income_of_income_in_percent" => balance.cash_eur_money.income_of_income_of_income_in_percent,
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

      money_creator = MoneyCreator.new

      cash = Cash.new(
        rub_money: money_creator.build_rub(
          value: cash_data.dig("rub", "value").to_f, 
          initial_value_in_percent: cash_data.dig("rub", "initial_value_in_percent").to_f, 
          income_in_percent: cash_data.dig("rub", "income_in_percent"), 
          income_of_income_in_percent: cash_data.dig("rub", "income_of_income_in_percent"), 
          income_of_income_of_income_in_percent: cash_data.dig("rub", "income_of_income_of_income_in_percent")
        ),
        usd_money: money_creator.build_usd(
          value: cash_data.dig("usd", "value").to_f, 
          initial_value_in_percent: cash_data.dig("usd", "initial_value_in_percent").to_f, 
          income_in_percent: cash_data.dig("usd", "income_in_percent"), 
          income_of_income_in_percent: cash_data.dig("usd", "income_of_income_in_percent"), 
          income_of_income_of_income_in_percent: cash_data.dig("usd", "income_of_income_of_income_in_percent")
        ),
        eur_money: money_creator.build_eur(
          value: cash_data.dig("eur", "value").to_f, 
          initial_value_in_percent: cash_data.dig("eur", "initial_value_in_percent").to_f, 
          income_in_percent: cash_data.dig("eur", "income_in_percent"), 
          income_of_income_in_percent: cash_data.dig("eur", "income_of_income_in_percent"), 
          income_of_income_of_income_in_percent: cash_data.dig("eur", "income_of_income_of_income_in_percent")
        )
      )

      balance = Balance.new(id: balace_record.id, cash: cash)
      investment_creator = InvestmentCreator.new(balance)
      balance.investments = investments_data.map do |investment|
        investment_creator.build(
          type: investment["type"],
          name: investment["name"],
          price: investment["price"],
          invested_money: investment["invested_money"],
          status: investment["status"]
        )
      end
      balance
    end

    def self.save(balance)
      cash = {
        "rub" =>  {
          "value" => balance.cash_rub_money.value,
          "initial_value_in_percent" => balance.cash_rub_money.initial_value_in_percent,
          "income_in_percent" => balance.cash_rub_money.income_in_percent,
          "income_of_income_in_percent" => balance.cash_rub_money.income_of_income_in_percent,
          "income_of_income_of_income_in_percent" => balance.cash_rub_money.income_of_income_of_income_in_percent,
        },
        "usd" =>  {
          "value" => balance.cash_usd_money.value,
          "initial_value_in_percent" => balance.cash_usd_money.initial_value_in_percent,
          "income_in_percent" => balance.cash_usd_money.income_in_percent,
          "income_of_income_in_percent" => balance.cash_usd_money.income_of_income_in_percent,
          "income_of_income_of_income_in_percent" => balance.cash_usd_money.income_of_income_of_income_in_percent,
        },
        "eur" =>  {
          "value" => balance.cash_eur_money.value,
          "initial_value_in_percent" => balance.cash_eur_money.initial_value_in_percent,
          "income_in_percent" => balance.cash_eur_money.income_in_percent,
          "income_of_income_in_percent" => balance.cash_eur_money.income_of_income_in_percent,
          "income_of_income_of_income_in_percent" => balance.cash_eur_money.income_of_income_of_income_in_percent,
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
          "price" => {
            "currency" => investment.price_currency,
            "value" => investment.price_value,
          },
          "invested_money" => {
            "currency" => investment.invested_money.currency,
            "value" => investment.invested_money.value,
            "initial_value_in_percent" => investment.invested_money.initial_value_in_percent,
            "income_in_percent" => investment.invested_money.income_in_percent,
            "income_of_income_in_percent" => investment.invested_money.income_of_income_in_percent,
            "income_of_income_of_income_in_percent" => investment.invested_money.income_of_income_of_income_in_percent,
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
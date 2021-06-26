module Repositories
  class BalanceRepository
    def self.create(balance)
      cash = {
        "rub" =>  {
          "initial_value" => balance.cash_rub_money.initial_value,
          "income" => balance.cash_rub_money.income,
          "income_of_income" => balance.cash_rub_money.income_of_income,
          "income_of_income_of_income" => balance.cash_rub_money.income_of_income_of_income,
        },
        "usd" =>  {
          "initial_value" => balance.cash_usd_money.initial_value,
          "income" => balance.cash_usd_money.income,
          "income_of_income" => balance.cash_usd_money.income_of_income,
          "income_of_income_of_income" => balance.cash_usd_money.income_of_income_of_income,
        },
        "eur" =>  {
          "initial_value" => balance.cash_eur_money.initial_value,
          "income" => balance.cash_eur_money.income,
          "income_of_income" => balance.cash_eur_money.income_of_income,
          "income_of_income_of_income" => balance.cash_eur_money.income_of_income_of_income,
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
        rub_money: money_creator.build_rub(initial_value: cash_data.dig("rub", "initial_value").to_f, income: cash_data.dig("rub", "income"), income_of_income: cash_data.dig("rub", "income_of_income"), income_of_income_of_income: cash_data.dig("rub", "income_of_income_of_income")),
        usd_money: money_creator.build_usd(initial_value: cash_data.dig("usd", "initial_value").to_f, income: cash_data.dig("usd", "income"), income_of_income: cash_data.dig("usd", "income_of_income"), income_of_income_of_income: cash_data.dig("usd", "income_of_income_of_income")),
        eur_money: money_creator.build_eur(initial_value: cash_data.dig("eur", "initial_value").to_f, income: cash_data.dig("eur", "income"), income_of_income: cash_data.dig("eur", "income_of_income"), income_of_income_of_income: cash_data.dig("eur", "income_of_income_of_income"))
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
          "initial_value" => balance.cash_rub_money.initial_value,
          "income" => balance.cash_rub_money.income,
          "income_of_income" => balance.cash_rub_money.income_of_income,
          "income_of_income_of_income" => balance.cash_rub_money.income_of_income_of_income,
        },
        "usd" =>  {
          "initial_value" => balance.cash_usd_money.initial_value,
          "income" => balance.cash_usd_money.income,
          "income_of_income" => balance.cash_usd_money.income_of_income,
          "income_of_income_of_income" => balance.cash_usd_money.income_of_income_of_income,
        },
        "eur" =>  {
          "initial_value" => balance.cash_eur_money.initial_value,
          "income" => balance.cash_eur_money.income,
          "income_of_income" => balance.cash_eur_money.income_of_income,
          "income_of_income_of_income" => balance.cash_eur_money.income_of_income_of_income,
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
            "initial_value" => investment.invested_money.initial_value,
            "income" => investment.invested_money.income,
            "income_of_income" => investment.invested_money.income_of_income,
            "income_of_income_of_income" => investment.invested_money.income_of_income_of_income,
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
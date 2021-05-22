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
        {
          "type" => investment.type,
          "name" => investment.name,
          "status" => investment.status,
          "price" => {
            "currency" => investment.price_currency,
            "value" => investment.price_value,
          }
        }
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
        price = money_creator.build(currency: investment.dig("price","currency"), value: investment.dig("price","value"))
        klass.new(name: investment["name"], initial_price: price, balance: balance, status: investment["status"])
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
        {
          "type" => investment.type,
          "name" => investment.name,
          "status" => investment.status,
          "price" => {
            "currency" => investment.price_currency,
            "value" => investment.price_value,
          }
        }
      end
      BalanceRecord.where(id: balance.id).update(cash: cash.to_json, investments: investments.to_json)
    end

    private

    def self.balance_table
      DB[:balances]
    end

    class BalanceRecord <  Sequel::Model(:balances)
    end


  end
end
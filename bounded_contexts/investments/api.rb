module FinancialConsultant
  module Investments
    class API < Roda
      plugin :json

      route do |r|
        r.on 'balance' do
          r.get true do
            balance = Repositories::BalanceRepository.fetch
            { 
              cash: {
                rub: balance.cash_rub_money_value,
                usd: balance.cash_usd_money_value,
                eur: balance.cash_eur_money_value
              },
              total_equity: {
                rub: balance.total_equity(Currency::RUB),
                usd: balance.total_equity(Currency::USD),
                eur: balance.total_equity(Currency::EUR),
              },
              investments: balance.investments.map do |investment|
                {
                  type: investment.type,
                  name: investment.name,
                  status: investment.status,
                  price: {
                    currency: investment.price.currency,
                    value: investment.price.value
                  },
                  invested_money: {
                    currency: investment.invested_money.currency,
                    initial_value: investment.invested_money.initial_value,
                    income: investment.invested_money.income,
                    income_of_income: investment.invested_money.income_of_income,
                    income_of_income_of_income: investment.invested_money.income_of_income_of_income,
                  }
                } 
              end
            }
          end

          r.on 'replenish' do
            r.post true do
              balance = Repositories::BalanceRepository.fetch
              money_creator = MoneyCreator.new
              money = money_creator.build(currency: r.params.dig("money", "currency"), initial_value: r.params.dig("money", "value"))
              balance.replenish(money)

              Repositories::BalanceRepository.save(balance)
              { 
                cash: {
                  rub: balance.cash_rub_money_value,
                  usd: balance.cash_usd_money_value,
                  eur: balance.cash_eur_money_value
                },
                total_equity: {
                  rub: balance.total_equity(Currency::RUB),
                  usd: balance.total_equity(Currency::USD),
                  eur: balance.total_equity(Currency::EUR),
                },
                investments: balance.investments.map do |investment|
                  {
                    type: investment.type,
                    name: investment.name,
                    status: investment.status,
                    price: {
                      currency: investment.price.currency,
                      value: investment.price.value
                    },
                    invested_money: {
                      currency: investment.invested_money.currency,
                      initial_value: investment.invested_money.initial_value,
                      income: investment.invested_money.income,
                      income_of_income: investment.invested_money.income_of_income,
                      income_of_income_of_income: investment.invested_money.income_of_income_of_income,
                    }
                  } 
                end
              }
            end
          end
        end

        r.on 'investments' do
          r.on 'open' do
            r.post true do
              balance = Repositories::BalanceRepository.fetch
              
              investment_creator = InvestmentCreator.new(balance)
              investment = investment_creator.build(
                name: r.params.dig("investment", "name"),
                type: r.params.dig("investment", "type"),
                price: r.params.dig("investment", "price"),
              )

              investment.open

              Repositories::BalanceRepository.save(balance)
              { 
                investment: {
                  type: investment.type,
                  name: investment.name,
                  status: investment.status,
                  price: {
                    currency: investment.price.currency,
                    value: investment.price.value
                  },
                  invested_money: {
                    currency: investment.invested_money.currency,
                    initial_value: investment.invested_money.initial_value,
                    income: investment.invested_money.income,
                    income_of_income: investment.invested_money.income_of_income,
                    income_of_income_of_income: investment.invested_money.income_of_income_of_income,
                  }                  
                },
              }
            end
          end

          r.on 'close' do
            r.post true do
              balance = Repositories::BalanceRepository.fetch

              if investment = balance.find_investment(name: r.params.dig("investment", "name"))
                investment.close
                Repositories::BalanceRepository.save(balance)

                { 
                  investment: {
                    type: investment.type,
                    name: investment.name,
                    status: investment.status,
                    price: {
                      currency: investment.price.currency,
                      value: investment.price.value
                    },
                    invested_money: {
                      currency: investment.invested_money.currency,
                      initial_value: investment.invested_money.initial_value,
                      income: investment.invested_money.income,
                      income_of_income: investment.invested_money.income_of_income,
                      income_of_income_of_income: investment.invested_money.income_of_income_of_income,
                    }                  
                  },
                }
              else
                {
                  status: "skipped"
                }
              end
            end
          end

          r.on 'dividend' do
            r.post true do
              balance = Repositories::BalanceRepository.fetch
              if investment = balance.find_investment(name: r.params.dig("investment", "name"))
                money_creator = MoneyCreator.new
                dividend = ::Investments::Dividend.new(currency: r.params.dig("dividend", "currency"), value: r.params.dig("dividend", "value").to_f)
                investment.add_dividend(dividend)
                Repositories::BalanceRepository.save(balance)
                { 
                  investment: {
                    type: investment.type,
                    name: investment.name,
                    status: investment.status,
                    price: {
                      currency: investment.price.currency,
                      value: investment.price.value
                    },
                    invested_money: {
                      currency: investment.invested_money.currency,
                      initial_value: investment.invested_money.initial_value,
                      income: investment.invested_money.income,
                      income_of_income: investment.invested_money.income_of_income,
                      income_of_income_of_income: investment.invested_money.income_of_income_of_income,
                    }              
                  },
                }
              else
                {
                  status: "skipped"
                }
              end
            end
          end

          r.on 'expense' do
            r.post true do
              balance = Repositories::BalanceRepository.fetch
              if investment = balance.find_investment(name: r.params.dig("investment", "name"))
                expense = ::Investments::Expense.new(currency: r.params.dig("expense", "currency"), value: r.params.dig("expense", "value").to_f)
                investment.add_expense(expense)
                Repositories::BalanceRepository.save(balance)
                { 
                  investment: {
                    type: investment.type,
                    name: investment.name,
                    status: investment.status,
                    price: {
                      currency: investment.price.currency,
                      value: investment.price.value
                    },
                    invested_money: {
                      currency: investment.invested_money.currency,
                      initial_value: investment.invested_money.initial_value,
                      income: investment.invested_money.income,
                      income_of_income: investment.invested_money.income_of_income,
                      income_of_income_of_income: investment.invested_money.income_of_income_of_income,
                    }              
                  },
                }
              else
                {
                  status: "skipped"
                }
              end
            end
          end

        end
      end
    end
  end
end
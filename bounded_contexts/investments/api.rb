module FinancialConsultant
  module Investments
    class API < Roda
      plugin :json

      route do |r|
        r.on 'balance' do
          r.get true do
            balance = Repositories::BalanceRepository.fetch
            Serializers::BalanceSerializer.new(balance).serialize
          end

          r.on 'replenish' do
            r.post true do
              # Q?: should we hide using repositories in the Commands?
              balance = Repositories::BalanceRepository.fetch 
              replenish_balance_command = Commands::ReplenishBalanceCommand.new(
                balance: balance,
                currency: r.params.dig("money", "currency"),
                value: r.params.dig("money", "value")
              )
              replenish_balance_command.execute

              Repositories::BalanceRepository.save(balance)
              Serializers::BalanceSerializer.new(balance).serialize
            end
          end
        end

        r.on 'investments' do
          r.on 'open' do
            r.post true do
              balance = Repositories::BalanceRepository.fetch
              open_investment_command = Commands::OpenInvestmentCommand.new(
                balance: balance,
                investment_name: r.params.dig("investment", "name"),
                investment_type: r.params.dig("investment", "type"),
                investment_price: r.params.dig("investment", "price"),
              )
              open_investment_command.execute
              
              Repositories::BalanceRepository.save(balance)
              Serializers::InvestmentSerializer.new(
                balance.find_investment(name: r.params.dig("investment", "name"))
              ).serialize
            end
          end

          r.on 'close' do
            r.post true do
              balance = Repositories::BalanceRepository.fetch

              if investment = balance.find_investment(name: r.params.dig("investment", "name"))
                investment.close
                Repositories::BalanceRepository.save(balance)

                Serializers::InvestmentSerializer.new(investment).serialize
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
                
                Serializers::InvestmentSerializer.new(investment).serialize
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
                
                Serializers::InvestmentSerializer.new(investment).serialize
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
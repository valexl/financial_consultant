module Investments
  class Base
    attr_reader :name, :initial_price, :price, :total_earnings, :total_costs, :balance, :status
    attr_writer :status
    private :balance

    def initialize(name:, initial_price:, balance:, total_costs: nil, total_earning: nil, price: nil, status: nil)
      @name = name
      @initial_price = initial_price
      @price = price || initial_price
      ############
      ## TODO: avoid using direct creation. This is a hotfix
      ############
      @total_earnings = total_earning ||= Money.new(currency: initial_price.currency)
      @total_costs = total_costs ||= Money.new(currency: initial_price.currency)
      ############
      ############
      @balance = balance
      @status = status
    end

    def opened?
      @status == "opened"
    end

    def closed?
      @status == "closed"
    end
    
    def balance_id
      balance.id
    end

    def type
      self.class::TYPE
    end

    def add_costs(costs)
      @total_costs += costs
    end
      
    def initial_price_value
      initial_price.value
    end

    def initial_price_currency
      initial_price.currency
    end

    def initial_price_income
      initial_price.income
    end

    def initial_price_income_of_income
      initial_price.income_of_income
    end

    def initial_price_income_of_income_of_income
      initial_price.income_of_income_of_income
    end

    def price_value
      price.value
    end

    def price_currency
      price.currency
    end

    def price_income
      price.income
    end

    def price_income_of_income
      price.income_of_income
    end

    def price_income_of_income_of_income
      price.income_of_income_of_income
    end

    def value(currency)
      @price.exchange(currency).value
    end

    def open
      @status = "pending"
      @balance.notify(self, 'open_investment')
    end

    def mark_opened
      @status = "opened"
    end

    def mark_closed
      @status = "closed"
    end

    def receive_earnings(earnings)
      return if closed?

      @total_earnings = if @total_earnings.nil?
                          earnings
                        else
                          @total_earnings + earnings
                        end
      @balance.notify(earnings, 'investment_earnings_receiving_request')
    end

    def reimburse_costs(costs)
      return if closed?
      add_costs(costs)
      @balance.notify(costs, 'investment_costs_reimbursing_request')
    end

    def close
      @balance.notify(self, 'close_investment')
    end

    def change_price(new_price)
      @price = new_price
    end

    def delta_price
      price = @price.convert_to_the_same_proportion(@initial_price)
      result = price - @initial_price
      result = result.move_all_to_one_level if result.positive?
      result
    end

    # https://en.wikipedia.org/wiki/Net_interest_income
    def net_interest_income
      price = @price.convert_to_the_same_proportion(@initial_price)

      total_earnings = @total_earnings.convert_to_the_same_proportion(@initial_price)
      total_costs = @total_costs.convert_to_the_same_proportion(@initial_price)

      delta_earnings = total_earnings - total_costs
      delta_earnings = delta_earnings.move_all_to_one_level if delta_earnings.positive?

      delta_price + delta_earnings
    end
  end
end

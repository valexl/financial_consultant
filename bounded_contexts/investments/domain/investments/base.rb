module Investments
  class Base
    attr_reader :name, :initial_price, :price, :total_earnings, :total_costs, :balance
    attr_accessor :id
    private :balance

    def initialize(id: nil, name:, initial_price:, balance:, price: nil)
      @id = id
      @name = name
      @initial_price = initial_price
      @price = price || initial_price
      ############
      ## TODO: avoid using direct creation. This is a hotfix
      ############
      @total_earnings = Money.new(currency: initial_price.currency)
      @total_costs = Money.new(currency: initial_price.currency)
      ############
      ############
      @balance = balance
      @status = nil
    end

    def balance_id
      balance.id
    end

    def type
      self.class::TYPE
    end
      

    def price_value
      price.value
    end

    def price_currency
      price.currency
    end

    def value(currency)
      @price.exchange(currency).value
    end

    def open
      @balance.notify(self, 'investment_opening_request')
      @status = 'opened'
    end

    def receive_earnings(earnings)
      return if @status == 'closed'

      @total_earnings = if @total_earnings.nil?
                          earnings
                        else
                          @total_earnings + earnings
                        end
      @balance.notify(earnings, 'investment_earnings_receiving_request')
    end

    def reimburse_costs(costs)
      return if @status == 'closed'

      @total_costs += costs
      @balance.notify(costs, 'investment_costs_reimbursing_request')
    end

    def close
      @balance.notify(self, 'investment_closed')
      @status = 'closed'
    end

    def change_price(price)
      @price = price
    end

    def take_profit
      price = @price.convert_to_the_same_proportion(@initial_price)
      delta_price = price - @initial_price
      delta_price = delta_price.move_all_to_one_level if delta_price.positive?
      change_price(delta_price)
      @balance.notify(delta_price, 'profit_taken')
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

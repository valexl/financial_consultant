module Investments
  class Base
    attr_reader :name, :price, :invested_money

    def initialize(name:, price:, balance:, invested_money: nil)
      @name = name
      @price = price
      @balance = balance
      @invested_money = invested_money || Money.new(currency: price_currency)
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

    def invest_money(money)
      @invested_money = @invested_money + money
    end

    def change_price(new_price)
      @price = new_price
    end

    def profit
      return invested_money.clone(0) unless price_difference.positive?
      invested_money
        .clone(price_difference)
        .lock_in_profits
    end

    def loss
      return invested_money.clone(0) if price_difference.positive?
      invested_money
        .clone(-price_difference)
    end

    def open
      @balance.notify(self, "open_investment")
    end

    def close
      @balance.notify(self, "close_investment")
    end

    private

    def price_difference
      price_value - invested_money.value
    end
  end
end

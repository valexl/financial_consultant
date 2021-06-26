module Investments
  class Base
    TYPE = "Generic"
    attr_reader :name, :price, :status 
    attr_accessor :invested_money

    def initialize(name:, price:, balance:, status: "pending", invested_money: nil)
      @name = name
      @price = price
      @balance = balance
      @invested_money = invested_money || Money.new(currency: price_currency)
      @status = status
    end

    def type
      self.class::TYPE
    end

    def pending?
      @status == "pending"
    end

    def opened?
      @status == "opened"
    end

    def closed?
      @status == "closed"
    end

    def mark_opened
      @status = "opened"
    end

    def mark_closed
      @status = "closed"
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

    def add_expense(expense)
      @balance.notify("add_expense", self, expense)
    end

    def add_dividend(dividend)
      @balance.notify("add_dividend", self, dividend)
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
      @balance.notify("open_investment", self)
    end

    def close
      @balance.notify("close_investment", self)
    end

    private

    def price_difference
      price.value - invested_money.value
    end
  end
end

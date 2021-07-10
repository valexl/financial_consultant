class InvestmentCreator
  def initialize(balance)
    @balance = balance
  end

  def build(type:, name:, price:, status: nil, invested_money: nil)
    klass = type == "apartment" ? Investments::ApartmentInvestment : Investments::StockInvestment

    klass.new(
      name: name,
      price: build_price(currency: price["currency"], value: price["value"]),
      balance: @balance,
      status: status,
      invested_money: build_invested_money(invested_money)
        
    )
  end

  private

  def klass(type)
    return Investments::ApartmentInvestment if type == "apartment"
    return Investments::StockInvestment if type == "stock"
    raise UnsupportedInvestmentTypeError.new
  end
  
  def build_price(currency:, value:)
    Investments::Price.new(currency: currency, value: value.to_f)
  end

  def build_invested_money(invested_money_attribute)
    return nil if invested_money_attribute.nil?

    money_creator.build(
      currency: invested_money_attribute["currency"],
      initial_value: invested_money_attribute["initial_value"],
      income: invested_money_attribute["income"],
      income_of_income: invested_money_attribute["income_of_income"],
      income_of_income_of_income: invested_money_attribute["income_of_income_of_income"],
    )
  end

  def money_creator
    MoneyCreator.new
  end

  class UnsupportedInvestmentTypeError < Exception
  end
end

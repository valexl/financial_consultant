class InvestmentCreator
  def initialize(balance)
    @balance = balance
    @money_creator = MoneyCreator.new
  end

  def build(type:, name:, status:, invested_money: , price:)
    klass = type == "apartment" ? Investments::ApartmentInvestment : Investments::StockInvestment

    klass.new(
      name: name,
      price: build_price(currency: price["currency"], value: price["value"]),
      balance: @balance,
      status: status,
      invested_money: build_invested_money(
        currency: invested_money["currency"],
        initial_value: invested_money["initial_value"],
        income: invested_money["income"],
        income_of_income: invested_money["income_of_income"],
        income_of_income_of_income: invested_money["income_of_income_of_income"],
      )
    )
  end

  private
  
  def build_price(currency:, value:)
    Investments::Price.new(currency: currency, value: value)
  end

  def build_invested_money(currency:, initial_value:, income:, income_of_income:, income_of_income_of_income:)
    @money_creator.build(
      currency: currency, 
      initial_value: initial_value, 
      income: income, 
      income_of_income: income_of_income, 
      income_of_income_of_income: income_of_income_of_income
    )
  end
end

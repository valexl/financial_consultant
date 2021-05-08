class MoneyCreator
  attr_accessor :builder

  def initialize(builder)
    @builder = builder
  end

  def build(value:, currency:, income: 0, income_of_income: 0, income_of_income_of_income: 0)
    builder.value = value
    builder.currency = currency
    builder.income = income
    builder.income_of_income = income_of_income
    builder.income_of_income_of_income = income_of_income_of_income
    result = builder.money_object
    builder.reset
    result
  end

  def build_rub(value:, income: 0, income_of_income: 0, income_of_income_of_income: 0)
    build(
      value: value,
      income: income,
      income_of_income: income_of_income,
      income_of_income_of_income: income_of_income_of_income,
      currency: Currency::RUB
    )
  end

  def build_usd(value:, income: 0, income_of_income: 0, income_of_income_of_income: 0)
    build(
      value: value,
      income: income,
      income_of_income: income_of_income,
      income_of_income_of_income: income_of_income_of_income,
      currency: Currency::USD
    )
  end

  def build_eur(value:, income: 0, income_of_income: 0, income_of_income_of_income: 0)
    build(
      value: value,
      income: income,
      income_of_income: income_of_income,
      income_of_income_of_income: income_of_income_of_income,
      currency: Currency::EUR
    )
  end
end

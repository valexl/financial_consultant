class MoneyCreator
  attr_accessor :builder

  def initialize(builder)
    @builder = builder
  end

  def build(initial_value:, currency:, income: 0, income_of_income: 0, income_of_income_of_income: 0)
    builder.initial_value = initial_value.to_f
    builder.currency = currency
    builder.income = income.to_f
    builder.income_of_income = income_of_income.to_f
    builder.income_of_income_of_income = income_of_income_of_income.to_f
    result = builder.money_object
    builder.reset
    result
  end

  def build_rub(initial_value:, income: 0, income_of_income: 0, income_of_income_of_income: 0)
    build(
      initial_value: initial_value,
      income: income,
      income_of_income: income_of_income,
      income_of_income_of_income: income_of_income_of_income,
      currency: Currency::RUB
    )
  end

  def build_usd(initial_value:, income: 0, income_of_income: 0, income_of_income_of_income: 0)
    build(
      initial_value: initial_value,
      income: income,
      income_of_income: income_of_income,
      income_of_income_of_income: income_of_income_of_income,
      currency: Currency::USD
    )
  end

  def build_eur(initial_value:, income: 0, income_of_income: 0, income_of_income_of_income: 0)
    build(
      initial_value: initial_value,
      income: income,
      income_of_income: income_of_income,
      income_of_income_of_income: income_of_income_of_income,
      currency: Currency::EUR
    )
  end
end

class MoneyCreator
  def build(initial_value:, income: 0, income_of_income: 0, income_of_income_of_income: 0, currency:)
    Money.new(
      currency: currency,
      initial_value: initial_value,
      income: income,
      income_of_income: income_of_income,
      income_of_income_of_income: income_of_income_of_income,
    )
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

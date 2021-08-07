class MoneyCreator
  def build(value:, initial_value_in_percent: 1, income_in_percent: 0, income_of_income_in_percent: 0, income_of_income_of_income_in_percent: 0, currency:)
    Money.new(
      currency: currency,
      value: value.to_f,
      initial_value_in_percent: initial_value_in_percent,
      income_in_percent: income_in_percent.to_f,
      income_of_income_in_percent: income_of_income_in_percent.to_f,
      income_of_income_of_income_in_percent: income_of_income_of_income_in_percent.to_f,
    )
  end

  def build_rub(value:, initial_value_in_percent: 1, income_in_percent: 0, income_of_income_in_percent: 0, income_of_income_of_income_in_percent: 0)
    build(
      value: value, 
      initial_value_in_percent: initial_value_in_percent,
      income_in_percent: income_in_percent, 
      income_of_income_in_percent: income_of_income_in_percent, 
      income_of_income_of_income_in_percent: income_of_income_of_income_in_percent,
      currency: Currency::RUB
    )
  end

  def build_usd(value:, initial_value_in_percent: 1, income_in_percent: 0, income_of_income_in_percent: 0, income_of_income_of_income_in_percent: 0)
    build(
      value: value, 
      initial_value_in_percent: initial_value_in_percent,
      income_in_percent: income_in_percent, 
      income_of_income_in_percent: income_of_income_in_percent, 
      income_of_income_of_income_in_percent: income_of_income_of_income_in_percent,
      currency: Currency::USD
    )
  end

  def build_eur(value:, initial_value_in_percent: 1, income_in_percent: 0, income_of_income_in_percent: 0, income_of_income_of_income_in_percent: 0)
    build(
      value: value, 
      initial_value_in_percent: initial_value_in_percent,
      income_in_percent: income_in_percent, 
      income_of_income_in_percent: income_of_income_in_percent, 
      income_of_income_of_income_in_percent: income_of_income_of_income_in_percent,
      currency: Currency::EUR
    )
  end
end

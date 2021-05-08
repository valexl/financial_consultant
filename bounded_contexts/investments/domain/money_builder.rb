class MoneyBuilder
  MONEY_CLASS = Money

  attr_writer :value, :currency, :income, :income_of_income, :income_of_income_of_income

  def initialize
    reset
  end

  def reset
    @value = 0
    @currency = nil
    @income = 0
    @income_of_income = 0
    @income_of_income_of_income = 0
    @money_object = self.class::MONEY_CLASS.new
  end

  def money_object
    @money_object.currency = @currency
    @money_object.initial_value = @value - @income - @income_of_income - @income_of_income_of_income
    @money_object.income = @income
    @money_object.income_of_income = @income_of_income
    @money_object.income_of_income_of_income = @income_of_income_of_income
    @money_object
  end
end

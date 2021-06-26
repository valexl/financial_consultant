class Money
  attr_accessor :currency
  attr_reader :items, :initial_value, :income, :income_of_income, :income_of_income_of_income
  
  def initialize(currency:, initial_value: 0, income: 0, income_of_income: 0, income_of_income_of_income: 0)
    @currency = currency
    @initial_value = initial_value
    @income = income
    @income_of_income = income_of_income
    @income_of_income_of_income = income_of_income_of_income
  end

  def to_s
    value.to_s
  end

  def +(money)
    return self if money.currency != currency
    self.class.new(
      currency: currency,
      initial_value: (initial_value + money.initial_value).round(4),
      income: (income + money.income).round(4),
      income_of_income: (income_of_income + money.income_of_income).round(4),
      income_of_income_of_income: (income_of_income_of_income + money.income_of_income_of_income).round(4),
    )
  end

  def -(money)
    return self if money.currency != currency
    # Do we really need that? Why can't we just allow negative values as anyway it won't affect value
    subtrahend_items = [
      money.initial_value,
      money.income,
      money.income_of_income,
      money.income_of_income_of_income
    ]
    result = [
      initial_value,
      income,
      income_of_income,
      income_of_income_of_income
    ]

    value_from_previous_level = 0
    (0..3).reverse_each do |level|
      diff = result[level] - (subtrahend_items[level] + value_from_previous_level)
      if diff >= 0
        result[level] = diff
        (level..3).each do |index|
          subtrahend_items[index] = 0
        end
        value_from_previous_level = 0
      else
        result[level] = 0
        subtrahend_items[level] = - diff 
        value_from_previous_level = - diff
      end
    end
    subtrahend_items.each_with_index do |item, level|
      next if item.zero?
      level_was_covered = false
      result.each_with_index do |result_item, result_level|
        next if result_item.zero?
        next if level_was_covered
        if result_item >= item
          result[result_level] = result_item - item
          level_was_covered = true
        else
          item = item - result_item
          result[result_level] = 0
        end
      end
    end  

    result = result.map do |item|
      item.round(4)
    end  

    self.class.new(
      currency: currency,
      initial_value: result[0].round(4),
      income: result[1].round(4),
      income_of_income: result[2].round(4),
      income_of_income_of_income: result[3].round(4),
    )
  end  

  def exchange(new_currency)
    self.class.new(
      currency: new_currency,
      initial_value: Currency.exchange(initial_value, currency, new_currency),
      income: Currency.exchange(income, currency, new_currency),
      income_of_income: Currency.exchange(income_of_income, currency, new_currency),
      income_of_income_of_income: Currency.exchange(income_of_income_of_income, currency, new_currency),
    )
  end

  def positive?
    value.positive?
  end

  def >=(other)
    return false if other.currency != currency

    value >= other.value
  end

  def <(other)
    return false if other.currency != currency

    value < other.value
  end

  def add(money)
    self + money
  end

  def subtract(money)
    self - money
  end

  def clone(amount)
    given_income_of_income_of_income = (amount * income_of_income_of_income_in_percent).round(4)
    given_income_of_income = (amount * income_of_income_in_percent).round(4)
    given_income = (amount * income_in_percent).round(4)
    given_initial_value = (amount - (given_income + given_income_of_income + given_income_of_income_of_income)).round(4)

    money = self.class.new(
      currency: currency,
      initial_value: given_initial_value,
      income: given_income,
      income_of_income: given_income_of_income,
      income_of_income_of_income: given_income_of_income_of_income,
    )
  end

  def lock_in_profits
    self.class.new(
      currency: currency,
      initial_value: 0,
      income: initial_value,
      income_of_income: income,
      income_of_income_of_income: income_of_income + income_of_income_of_income
    )
  end

  def split(amount)
    raise NotEnoughMoney.new if value < amount
    money = clone(amount)
    new_money = self - money
    return [new_money, money]
  end

  def take_income_of_income_of_income
    money = self.class.new(
      currency: currency,
      initial_value: 0,
      income: 0,
      income_of_income: 0,
      income_of_income_of_income: income_of_income_of_income
    )
    new_money = self - money
    return [new_money, money]
  end

  def value
    (initial_value + income + income_of_income + income_of_income_of_income).round(4)
  end

  def initial_value_in_percent
    (initial_value.to_f/value)
  end

  def income_in_percent
    (income.to_f/value)
  end

  def income_of_income_in_percent
    (income_of_income.to_f/value)
  end

  def income_of_income_of_income_in_percent
    (income_of_income_of_income.to_f/value)
  end

  class NotEnoughMoney < Exception
  end
end

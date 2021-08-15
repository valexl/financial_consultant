class Money
  attr_accessor :currency
  attr_reader :items, :initial_value, :income, :income_of_income, :income_of_income_of_income,
  :value, :initial_value_in_percent, :income_in_percent, :income_of_income_in_percent, :income_of_income_of_income_in_percent
  
  def initialize(currency:, value: 0, initial_value_in_percent:, income_in_percent:, income_of_income_in_percent:, income_of_income_of_income_in_percent:)
    @currency = currency
    @value = value.to_f
    @initial_value_in_percent = initial_value_in_percent
    @income_in_percent = income_in_percent
    @income_of_income_in_percent = income_of_income_in_percent
    @income_of_income_of_income_in_percent = income_of_income_of_income_in_percent
    @initial_value = (value * initial_value_in_percent).round(4).to_f
    @income = (value * income_in_percent).round(4).to_f
    @income_of_income = (value * income_of_income_in_percent).round(4).to_f
    @income_of_income_of_income = (value * income_of_income_of_income_in_percent).round(4).to_f
  end

  def self.build(currency:, initial_value:, income:, income_of_income:, income_of_income_of_income:)
    new_value = initial_value + income + income_of_income + income_of_income_of_income
    if new_value == 0
      initial_value_in_percent = 0
      income_in_percent = 0
      income_of_income_in_percent = 0
      income_of_income_of_income_in_percent = 0
    else
      initial_value_in_percent = (initial_value.to_f / new_value)
      income_in_percent = (income.to_f / new_value)
      income_of_income_in_percent = (income_of_income.to_f / new_value)
      income_of_income_of_income_in_percent = (income_of_income_of_income.to_f / new_value)
    end  

    self.new(
      currency: currency,
      value: new_value.round(4),
      initial_value_in_percent: initial_value_in_percent,
      income_in_percent: income_in_percent,
      income_of_income_in_percent: income_of_income_in_percent,
      income_of_income_of_income_in_percent: income_of_income_of_income_in_percent,
    )    
  end  

  def to_s
    value.to_s
  end

  def +(money)
    return self if money.currency != currency

    new_value = value + money.value
    rate_a = value/new_value
    rate_b = money.value/new_value

    new_initial_value_in_percent = initial_value_in_percent * rate_a + money.initial_value_in_percent * rate_b
    new_income_in_percent = income_in_percent * rate_a + money.income_in_percent * rate_b
    new_income_of_income_in_percent = income_of_income_in_percent * rate_a + money.income_of_income_in_percent * rate_b
    new_income_of_income_of_income_in_percent = income_of_income_of_income_in_percent * rate_a + money.income_of_income_of_income_in_percent * rate_b

    self.class.new(
      currency: currency,
      value: new_value,
      initial_value_in_percent: new_initial_value_in_percent,
      income_in_percent: new_income_in_percent,
      income_of_income_in_percent: new_income_of_income_in_percent,
      income_of_income_of_income_in_percent: new_income_of_income_of_income_in_percent,
    )
  end

  def -(money)
    return self if money.currency != currency
    return self if money.value == 0
    result = Subtract.new(self, money).call

    self.class.new(
      currency: currency,
      value: result.value,
      initial_value_in_percent: result.initial_value_in_percent,
      income_in_percent: result.income_in_percent,
      income_of_income_in_percent: result.income_of_income_in_percent,
      income_of_income_of_income_in_percent: result.income_of_income_of_income_in_percent,
    )
  end  

  def exchange(new_currency)
    self.class.build(
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
      value: amount,
      initial_value_in_percent: initial_value_in_percent,
      income_in_percent: income_in_percent,
      income_of_income_in_percent: income_of_income_in_percent,
      income_of_income_of_income_in_percent: income_of_income_of_income_in_percent
    )
  end

  def lock_in_profits
    self.class.new(
      currency: currency,
      value: value,
      initial_value_in_percent: 0,
      income_in_percent: initial_value_in_percent,
      income_of_income_in_percent: income_in_percent,
      income_of_income_of_income_in_percent: income_of_income_in_percent + income_of_income_of_income_in_percent
    )
  end

  def split(amount)
    raise NotEnoughMoney.new if value < amount
    money = clone(amount)
    $ttt = true if amount == value
    new_money = self - money
    return [new_money, money]
  end

  def take_income_of_income_of_income
    money = self.class.new(
      currency: currency,
      value: income_of_income_of_income,
      initial_value_in_percent: 0,
      income_in_percent: 0,
      income_of_income_in_percent: 0,
      income_of_income_of_income_in_percent: 100
    )
    new_money = self - money
    return [new_money, money]
  end

  class Subtract
    def initialize(money_a, money_b)
      @value = money_a.value - money_b.value
      if @value == 0
        rate_a = 1
        rate_b = 1
      else
        rate_a = money_a.value/@value
        rate_b = money_b.value/@value
      end

      @minuend = [
        money_a.income_of_income_of_income_in_percent * rate_a,
        money_a.income_of_income_in_percent * rate_a,
        money_a.income_in_percent * rate_a,
        money_a.initial_value_in_percent * rate_a,
      ]
      @subtrahend = [
        money_b.income_of_income_of_income_in_percent * rate_b,
        money_b.income_of_income_in_percent * rate_b,
        money_b.income_in_percent * rate_b,
        money_b.initial_value_in_percent * rate_b,
      ]

      @result = [0, 0, 0, 0]
    end

    def call
      @result.each_with_index do |item, index|
        item = @minuend[index] - @subtrahend[index]
        if item < 0
          taken_value = take_value_from_previous_result(item.abs, index)
          item = - (item.abs - taken_value)
        end
        @result[index] = item
      end

      (1..@result.count-1).each do |index|
        diff = @result[index -1]
        if diff < 0
          @result[index -1] = 0 
          @result[index] = @result[index] - diff.abs
        end
      end

      @result = @minuend.clone if @result.sum == 0 # that means value and percentage is equal and we just need to use original one

      Result.new(@value, @result)
    end

    private

    def take_value_from_previous_result(required_value, position)
      allocated_value = 0
      (0..position-1).reverse_each do |index|
        if (diff = @result[index] - required_value ) >= 0
          allocated_value = required_value
          @result[index] = diff
          break # collect all required value
        else
          allocated_value += required_value - diff.abs
          @result[index] = 0
        end
      end
      allocated_value
    end
  end

  class Result
    attr_reader :value, :initial_value_in_percent, :income_in_percent, :income_of_income_in_percent, :income_of_income_of_income_in_percent
    def initialize(value, result)
      @value = value
      @initial_value_in_percent = result[3]
      @income_in_percent = result[2]
      @income_of_income_in_percent = result[1]
      @income_of_income_of_income_in_percent = result[0]
    end
  end

  class NotEnoughMoney < Exception
  end
end

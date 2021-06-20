class Money
  attr_accessor :currency
  attr_reader :items

  def initialize(currency: nil, items: nil)
    @currency = currency
    @items = items
    @items ||= [
      Item.new(value: 0, level: 0),
      Item.new(value: 0, level: 1),
      Item.new(value: 0, level: 2),
      Item.new(value: 0, level: 3)
    ]
  end

  def to_s
    value.to_s
  end

  def +(money)
    add(money)
  end

  def -(other)
    subtract(other)
  end

  def >=(other)
    return false if other.currency != currency

    value >= other.value
  end

  def <(other)
    return false if other.currency != currency

    value < other.value
  end

  def take(amount)
    # it looks like side-effect function... 
    given_income_of_income_of_income = (amount * income_of_income_of_income_in_percent).round(4)
    given_income_of_income = (amount * income_of_income_in_percent).round(4)
    given_income = (amount * income_in_percent).round(4)
    given_initial_value = amount - (given_income + given_income_of_income + given_income_of_income_of_income)

    money = self.class.new(
      currency: currency,
      items: [
        Item.new(value: given_initial_value, level: 0),
        Item.new(value: given_income, level: 1),
        Item.new(value: given_income_of_income, level: 2),
        Item.new(value: given_income_of_income_of_income, level: 3),
      ]
    )

    new_money = self - money
    self.initial_value = new_money.initial_value
    self.income = new_money.income
    self.income_of_income = new_money.income_of_income
    self.income_of_income_of_income = new_money.income_of_income_of_income

    money
  end

  def positive?
    value.positive?
  end

  def exchange(new_currency)
    result = []
    items_iterator.each_with_level do |item, level|
      new_value = Currency.exchange(item.value, currency, new_currency)
      result << Item.new(value: new_value, level: level)
    end
    self.class.new currency: new_currency, items: result
  end

  def add(money)
    return self if money.currency != currency
    return self unless money.positive?

    result = []
    items_iterator.each_with_level do |item, level|
      result << Item.new(value: item.value + money.items[level].value, level: level)
    end

    self.class.new currency: currency, items: result
  end

  def subtract(money)
    return self if money.currency != currency
    return self unless money.positive?
    return self if self < money
    subtrahend_items = [
      Item.new(value: money.initial_value, level: 0),
      Item.new(value: money.income, level: 1),
      Item.new(value: money.income_of_income, level: 2),
      Item.new(value: money.income_of_income_of_income, level: 3),
    ]


    result = [
      Item.new(value: initial_value, level: 0),
      Item.new(value: income, level: 1),
      Item.new(value: income_of_income, level: 2),
      Item.new(value: income_of_income_of_income, level: 3),
    ]

    value_from_previous_level = 0
    (0..3).reverse_each do |level|
      diff = result[level].value - (subtrahend_items[level].value + value_from_previous_level)
      if diff >= 0
        result[level].value = diff
        (level..3).each do |index|
          subtrahend_items[index].value = 0
        end
        value_from_previous_level = 0
      else
        result[level].value = 0
        subtrahend_items[level].value = - diff 
        value_from_previous_level = - diff
      end
    end

    subtrahend_items.each_with_index do |item, level|
      next if item.value.zero?
      level_was_covered = false
      result.each_with_index do |result_item, result_level|
        next if level_was_covered
        if result_item.value >= item.value
          result_item.value = result_item.value - item.value
          level_was_covered = true
        else
          item.value = item.value - result_item.value
          result_item.value = 0
        end
      end
    end
    result = result.map do |item|
      item.value = item.value.round(4)
      item
    end
    self.class.new currency: currency, items: result
  end

  def withdrawable
    money = self.class.new
    money.currency = currency
    money.income_of_income_of_income = withdrawable_items_iterator.sum { |item| item.value }
    money
  end

  def move_all_to_one_level
    # what is it !? It doesn't look like domain action... 
    new_money = self.class.new(currency: currency)
    new_money.initial_value = 0
    new_money.income = initial_value
    new_money.income_of_income = income
    new_money.income_of_income_of_income = value - new_money.value
    new_money
  end

  def initial_value
    @items[0].value
  end

  def initial_value=(value)
    @items[0].value = value
  end

  def income=(value)
    @items[1].value = value
  end

  def income
    @items[1].value
  end

  def income_of_income=(value)
    @items[2].value = value
  end

  def income_of_income
    @items[2].value
  end

  def income_of_income_of_income=(value)
    @items[3].value = value
  end

  def income_of_income_of_income
    @items[3].value
  end

  def value
    items.map(&:value).sum
  end

  def initial_value_in_percent
    (initial_value.to_f / value)
  end

  def income_in_percent
    (income.to_f / value)
  end

  def income_of_income_in_percent
    (income_of_income.to_f / value)
  end

  def income_of_income_of_income_in_percent
    (income_of_income_of_income.to_f / value)
  end

  private

  def items_iterator
    ItemsIterator.new(@items)
  end

  def withdrawable_items_iterator
    WithdrawableItemsIterator.new(@items)
  end

  class Item
    attr_accessor :value
    attr_reader :level

    def initialize(value:, level:)
      @value = value
      @level = level
    end
  end
end

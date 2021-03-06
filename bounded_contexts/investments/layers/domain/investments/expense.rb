module Investments
  class Expense
    attr_reader :value, :currency
    
    def initialize(value:, currency:)
      @value = value
      @currency = currency
    end

    def positive?
      value.positive?
    end
  end
end
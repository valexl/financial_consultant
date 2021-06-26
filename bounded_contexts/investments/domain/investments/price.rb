module Investments
  class Price
    attr_reader :value, :currency
    
    def initialize(value:, currency:)
      @value = value
      @currency = currency
    end

    def exchange(new_currency)
      self.class.new(
        currency: new_currency,
        value: Currency.exchange(value, currency, new_currency)
      )
    end
  end
end
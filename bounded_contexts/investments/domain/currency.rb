class Currency
  USD = 'USD'.freeze
  EUR = 'EUR'.freeze
  RUB = 'RUB'.freeze

  EXCHANGE_RATES = {
    USD => {
      RUB => 75,
      EUR => 0.8,
      USD => 1
    },
    EUR => {
      RUB => 89,
      EUR => 1,
      USD => 0.8
    },
    RUB => {
      RUB => 1,
      EUR => 0.11,
      USD => 0.13
    }
  }.freeze

  def self.exchange(value, source_currency, destination_currency)
    value * EXCHANGE_RATES[source_currency][destination_currency]
  end
end
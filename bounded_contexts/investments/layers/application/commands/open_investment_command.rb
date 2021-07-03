module Commands
  class OpenInvestmentCommand < BaseCommand

    def initialize(balance:, investment_type:, investment_name:, investment_price: )
      @balance = balance
      @investment_type = investment_type
      @investment_name = investment_name
      @investment_price = investment_price
    end

    def execute
      investment_creator = InvestmentCreator.new(@balance)
      investment = investment_creator.build(
        name: @investment_name,
        type: @investment_type,
        price: @investment_price,
      )
      investment.open
    end
  end
end
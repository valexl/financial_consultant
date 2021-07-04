module Commands
  class OpenInvestmentCommand < BaseCommand

    def initialize(investment_type:, investment_name:, investment_price: )
      @investment_type = investment_type
      @investment_name = investment_name
      @investment_price = investment_price
    end

    def execute(balance)
      investment_creator = InvestmentCreator.new(balance)
      investment = investment_creator.build(
        name: @investment_name,
        type: @investment_type,
        price: @investment_price,
      )
      investment.open
      investment # TODO: check is it possible somehow to refactor it to return the same type as an argument
    end
  end
end
module Commands
  class CloseInvestmentCommand < BaseCommand

    def initialize(investment_name:)
      @investment_name = investment_name
    end

    def execute(balance)
      return unless investment = balance.find_investment(name: @investment_name)
      investment.close
      investment
    end
  end
end
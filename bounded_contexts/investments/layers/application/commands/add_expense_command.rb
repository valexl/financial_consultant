module Commands
  class AddExpenseCommand < BaseCommand

    def initialize(investment_name:, expense_currency:, expense_value: )
      @investment_name = investment_name
      @expense_currency = expense_currency
      @expense_value = expense_value.to_f
    end

    def execute(balance)
      return unless investment = balance.find_investment(name: @investment_name)
      expense = ::Investments::Expense.new(currency: @expense_currency, value: @expense_value)
      investment.add_expense(expense)
      investment
    end
  end
end
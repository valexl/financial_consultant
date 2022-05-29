module Application
  module Month
    class MonthApplicationService
      def initialize(repository:)
        @repository = repository
      end

      def start_month(command)
        month = Domain::Model::Month::Month.new(
          id: command.identity,
          year: command.year,
          month_number: command.month_number
        )
        @repository.create(month)
      end
    end
  end
end

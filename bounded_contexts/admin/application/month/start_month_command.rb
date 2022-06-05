module Admin
  module Application
    module Month
      class StartMonthCommand
        attr_reader :year, :month_number

        def initialize(year:, month_number:)
          @year = year
          @month_number = month_number
        end
      end
    end
  end
end

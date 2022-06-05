module Admin
  module Port
    module Adapter
      module Persistence
        class MemoryMonthRepository
          include Domain::Model::Month::MonthRepositoryInterface

          def initialize
            @records = []
          end

          def all_months
            @records
          end

          def create(month)
            @records << month
          end
        end
      end
    end
  end
end

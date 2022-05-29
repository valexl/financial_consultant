module Port
  module Adapter
    module Persistence
      class PGMonthRepository
        include Domain::Model::Month::MonthRepositoryInterface
      end
    end
  end
end

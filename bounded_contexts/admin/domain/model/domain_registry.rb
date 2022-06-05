module Admin
  module Domain
    module Model
      class DomainRegistry
        def self.start_month_service
          Month::StartMonthService.new
        end
      end
    end
  end
end
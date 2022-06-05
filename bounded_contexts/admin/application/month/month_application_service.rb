module Admin
  module Application
    module Month
      class MonthApplicationService
        def initialize(repository, consumer)
          @repository = repository
          @consumer = consumer
        end

        def start_month(command)
          Admin::Domain::Model::DomainEventPublisher.reset # double check it!!

          # it should do nothing if month was already started
          month = Admin::Domain::Model::DomainRegistry
            .start_month_service
            .call(year: command.year, month_number: command.month_number)
          
          @repository.create(month)
        end
      end
    end
  end
end

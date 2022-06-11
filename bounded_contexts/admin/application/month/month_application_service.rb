module Admin
  module Application
    module Month
      class MonthApplicationService
        def initialize(repository:, producer:, event_store:)
          # TODO: producer, event_store and may be repository have to be injected dependency and are handled via config/enviroment/*.rb files
          @repository = repository
          @producer = producer
          @event_store = event_store
        end

        def start_month(command)
          life_cycle = ApplicationServiceLifeCycle.new(
            producer: @producer, 
            event_store: @event_store
          )
          life_cycle.start # TODO may be use block here?

          # it should do nothing if month was already started
          month = Admin::Domain::Model::DomainRegistry
            .start_month_service
            .call(year: command.year, month_number: command.month_number)
          
          @repository.create(month)

          life_cycle.success
        rescue
          life_cycle.rollback
        end
      end
    end
  end
end

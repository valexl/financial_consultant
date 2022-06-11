module Admin
  module Application
    class ApplicationServiceLifeCycle
      def initialize(producer:, event_store:)
        # TODO: producer and event_store have to be injected dependency and are handled via config/enviroment/*.rb files
        @producer = producer
        @event_store = event_store
      end

      ############################
      #### EVENT HANDLER PART#####
      ############################
      def subscribed_to_event_type
        Common::Domain::Model::DomainEvent
      end

      def handle_event(event)
        @event_store.store_event(event)
      end
      ############################
      ############ END ###########
      ############################

      def start
        Admin::Domain::Model::DomainEventPublisher.reset
        Admin::Domain::Model::DomainEventPublisher.subscribe(self)
      end

      def success
        return if @event_store.new_events.empty?
        
        @producer.broadcast_events(@event_store.new_events)
      end

      def rollback
        @event_store.rollback
      end
    end
  end
end

module Admin
  module Application
    class ApplicationServiceLifeCycle
      def initialize(producer:, event_store:)
        # TODO: producer and event_store has to be injected dependency and are handled via config/enviroment/*.rb files
        @producer = producer
        @event_store = event_store
      end

      def handle_event(event)
        @event_store.store_event(event)
      end

      def start
        Admin::Domain::Model::DomainEventPublisher.reset
        Admin::Domain::Model::DomainEventPublisher.subscribe(self)
      end

      def success
        @event_store.new_events.each do |event|
          @producer.call(event)
        end
      end

      def failure
        @event_store.rollback
      end
    end
  end
end

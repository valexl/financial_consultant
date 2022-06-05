module Admin
  module Domain
    module Model
      class DomainEventPublisher

        def self.clear
          @subscribers = []
        end

        def self.subscribe(handler)
          @subscribers.push(handler)
        end

        def self.publish(event)
          @subscribers.each do |subscriber|
            if [event.class, Common::Domain::Model::DomainEvent].include?(subscriber.subscribed_to_event_type)
              subscriber.handle_event(event)
            end
          end
        end
      end
    end
  end
end
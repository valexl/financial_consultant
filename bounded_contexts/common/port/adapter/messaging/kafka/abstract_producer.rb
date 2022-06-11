module Common
  module Port
    module Adapter
      module Messaging
        module Kafka
          class AbstractProducer < ::Karafka::BaseResponder
            def self.broadcast_events(events)
              events.each do |event|
                self.call(event)
              end
            end

            def respond(event)
              raise 'Implement me'
            end
          end
        end
      end
    end
  end
end
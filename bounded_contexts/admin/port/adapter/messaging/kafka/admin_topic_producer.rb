module Admin
  module Port
    module Adapter
      module Messaging
        module Kafka
          class AdminTopicProducer < Common::Port::Adapter::Messaging::Kafka::AbstractProducer
            topic :admin

            def respond(event)
              respond_to :admin, event.to_h
            end
          end
        end
      end
    end
  end
end
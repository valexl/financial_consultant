module Port
  module Adapter
    module Messaging
      module Kafka
        class KafkaMonthStartedListener
          LISTENING_EVENT = "admin.month.month_started".freeze

          def initialize(repository)
            @repository = repository
          end
          # TODO: setup to listen kafka
          def filtered_dispatch(event_payload)
            return if event_payload["event"] != LISTENING_EVENT

            service = Application::Month::MonthApplicationService.new(repository: @repository)
            command = Application::Month::StartMonthCommand.new(
              id: event_payload["payload"]["id"],
              year: event_payload["payload"]["year"],
              month_number: event_payload["payload"]["month_number"],
            )
            service.start_month(command)
          end
        end
      end
    end
  end
end
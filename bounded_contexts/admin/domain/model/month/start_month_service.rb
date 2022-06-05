module Admin
  module Domain
    module Model
      module Month
        class StartMonthService

          def call(year:, month_number:)
            identity = Common::Domain::Model::Identity.new subdomain: 'admin', uniq_value: SecureRandom.urlsafe_base64(5)

            month = Month.new(id: identity, year: year, month_number: month_number)

            event = MonthStarted.new(year: year, month_number: month_number)
            DomainEventPublisher.publish(event)

            month
          end
        end
      end
    end
  end
end
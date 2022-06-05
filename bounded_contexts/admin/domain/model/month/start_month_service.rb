module Admin
  module Domain
    module Model
      module Month
        class StartMonthService

          def call(year:, month_number:)
            identity = Common::Domain::Model::Identity.new subdomain: 'admin', uniq_value: SecureRandom.urlsafe_base64(5)

            Month.new(id: identity, year: year, month_number: month_number)
          end
        end
      end
    end
  end
end
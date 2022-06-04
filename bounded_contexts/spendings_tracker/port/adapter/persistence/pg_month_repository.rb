module SpendingsTracker
  module Port
    module Adapter
      module Persistence
        class PGMonthRepository
          include Domain::Model::Month::MonthRepositoryInterface

          def all_months
            DB[:months].map do |raw|
              subdomain, uniq_value, created_at_f = raw[:id].split('-')
              created_at = Common::Domain::Model::CreatedAt.new(
                time: Time.at(created_at_f.to_r)
              )

              identity = Common::Domain::Model::Identity.new(
                subdomain: subdomain,
                uniq_value: uniq_value,
                created_at: created_at
              )

              Domain::Model::Month::Month.new(id: identity, year: raw[:year], month_number: raw[:month_number])
            end
          end

          def create(month)
            DB[:months].insert(
              id: month.id.to_s,
              year: month.year,
              month_number: month.month_number
            )
          end
        end
      end
    end
  end
end

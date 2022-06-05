module Admin
  module Domain
    module Model
      module Month
        class MonthStarted < Common::Domain::Model::DomainEvent
          attribute :subdomain, Common::Types::String.default { "admin" }

          attribute :year, Common::Types::Integer
          attribute :month_number, Common::Types::Integer
        end
      end
    end
  end
end
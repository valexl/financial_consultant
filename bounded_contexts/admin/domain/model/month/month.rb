module Admin
  module Domain
    module Model
      module Month
        class Month < Common::Domain::Model::Entity
          attribute :year, Common::Types::Strict::Integer
          attribute :month_number, Common::Types::Strict::Integer
        end
      end
    end
  end
end
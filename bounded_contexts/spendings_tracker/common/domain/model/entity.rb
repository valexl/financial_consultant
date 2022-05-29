module Common
  module Domain
    module Model
      class Entity < Dry::Struct
        attribute :id, Identity
      end
    end
  end
end
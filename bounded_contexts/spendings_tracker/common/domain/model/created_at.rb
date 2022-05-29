module Common
  module Domain
    module Model
      class CreatedAt < Dry::Struct
        attribute :time, Types::Time.optional.default { Time.now }

        def to_s
          time.to_r.to_s
        end
      end
    end
  end
end
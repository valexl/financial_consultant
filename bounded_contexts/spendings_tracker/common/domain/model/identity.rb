module Common
  module Domain
    module Model
      class Identity < Dry::Struct
        attribute :subdomain, Types::String
        attribute :uniq_value, Types::String
        attribute :created_at, CreatedAt.default { CreatedAt.new }

        def to_s
          "#{subdomain}-#{uniq_value}-#{created_at}"
        end
      end
    end
  end
end
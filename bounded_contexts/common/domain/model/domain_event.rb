module Common
  module Domain
    module Model
      class DomainEvent < Dry::Struct
        VERSION = "1.0".freeze

        attribute :id, Types::String.default { SecureRandom.urlsafe_base64(8) }
        attribute :subdomain, Types::String
        attribute :occurred_on, CreatedAt.default { CreatedAt.new }
        attribute :version, Types::String.default { VERSION }
      end
    end
  end
end

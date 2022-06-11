module Admin
  module Port
    module Adapter
      module Persistence
        class MemoryEventStore
          include Common::Event::Sourcing

          def initialize
            @storage = []
          end

          def store_event(event)
            @storage.push(event)
          end

          def new_events
            @storage
          end

          def rollback
            @storage = []
          end
        end
      end
    end
  end
end
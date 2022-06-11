module Common
  module Event
    module Sourcing
      def store(event)
        raise 'Implement me'
      end

      def rollback
        raise 'Implement me'
      end

      def new_events
        raise 'Implement me'
      end
    end
  end
end

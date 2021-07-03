module Commands
  class Base
    def execute
      raise NoImplementationError, "#{self.class} has not implemented method '#{__method__}'" 
    end
  end
end
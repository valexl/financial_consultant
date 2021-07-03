module Commands
  class BaseCommand
    def execute
      raise NoImplementationError, "#{self.class} has not implemented method '#{__method__}'" 
    end
  end
end
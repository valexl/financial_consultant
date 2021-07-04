module Commands
  class BaseCommand
    def execute(balance)
      raise NoImplementationError, "#{self.class} has not implemented method '#{__method__}'" 
    end
  end
end
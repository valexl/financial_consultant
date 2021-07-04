module Commands
  class CommandInvoker
    attr_accessor :command, :serializer

    def initialize(balance)
      @balance = balance
    end

    def execute_command
      @result  = command.execute(@balance)
    end

    def result
      serializer.new(@result).serialize
    end
  end
end
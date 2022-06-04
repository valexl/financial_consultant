module SpendingsTracker
  module Domain
    module Model
      module Month
        module MonthRepositoryInterface
          def all_months
            raise 'Implement me'
          end

          def create(_month)
            raise 'Implement me'
          end
        end
      end
    end
  end
end

module Application
  module Month
    class StartMonthCommand
      def initialize(id:, year:, month_number:)
        @id = id
        @year = year
        @month_number = month_number
      end

      def identity
        subdomain, uniq_value, created_at_f = @id.split('-')
        created_at = Common::Domain::Model::CreatedAt.new(
          time: Time.at(created_at_f.to_r)
        )

        Common::Domain::Model::Identity.new(
          subdomain: subdomain,
          uniq_value: uniq_value,
          created_at: created_at
        )
      end

      attr_reader :year, :month_number
    end
  end
end

module CfeParamBuilders
  class Dependants
    class << self
      def children(dependants:, count:)
        if dependants
          Array.new(count) do
            {
              date_of_birth: 11.years.ago.to_date,
              in_full_time_education: true,
              relationship: "child_relative",
              monthly_income: 0,
              assets_value: 0,
            }
          end
        else
          []
        end
      end

      def adults(dependants:, count:)
        if dependants
          Array.new(count) do
            {
              date_of_birth: 21.years.ago.to_date,
              in_full_time_education: false,
              relationship: "adult_relative",
              monthly_income: 0,
              assets_value: 0,
            }
          end
        else
          []
        end
      end
    end
  end
end

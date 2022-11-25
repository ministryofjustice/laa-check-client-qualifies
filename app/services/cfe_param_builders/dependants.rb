module CfeParamBuilders
  class Dependants
    class << self
      def call(details_form)
        child_dependants = Array.new(details_form.child_dependants) do
          {
            date_of_birth: 11.years.ago.to_date,
            in_full_time_education: true,
            relationship: "child_relative",
            monthly_income: 0,
            assets_value: 0,
          }
        end

        adult_dependants = Array.new(details_form.adult_dependants) do
          {
            date_of_birth: 21.years.ago.to_date,
            in_full_time_education: false,
            relationship: "adult_relative",
            monthly_income: 0,
            assets_value: 0,
          }
        end

        child_dependants + adult_dependants
      end
    end
  end
end

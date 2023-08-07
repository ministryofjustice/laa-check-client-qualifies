module CfeParamBuilders
  class Dependants
    class << self
      def call(details_form, dependant_incomes)
        adults = details_form.adult_dependants ? Array.new(details_form.adult_dependants_count, :adult) : []
        children = details_form.child_dependants ? Array.new(details_form.child_dependants_count, :child) : []

        (adults + children).zip(dependant_incomes || []).map do |person_type, income|
          {
            date_of_birth: (person_type == :adult ? 21 : 17).years.ago.to_date,
            in_full_time_education: person_type == :child,
            relationship: "#{person_type}_relative",
            income: build_income(income),
            assets_value: 0,
          }
        end
      end

      def build_income(income)
        return unless income

        {
          frequency: RegularTransactions::CFE_FREQUENCIES[income.frequency],
          amount: income.amount,
        }
      end
    end
  end
end

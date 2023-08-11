module CfeParamBuilders
  class Dependants
    class << self
      def call(details_form, dependant_incomes)
        adults = details_form.adult_dependants ? Array.new(details_form.adult_dependants_count, :adult) : []
        children = details_form.child_dependants ? Array.new(details_form.child_dependants_count, :child) : []

        # We tell CFE that child relatives with income are 17 and in full-time education. This is because
        # the specific age of the child does not affect the base allowance, but younger children
        # cannot have their income considered. Since we do not know the children's ages,
        # marking them as older means that if the client does provide income, CFE will consider it.
        # If they do not have income we assume they are under 16, as this puts their dependant allowance
        # in a more intuitive place on the CW form
        (adults + children).zip(dependant_incomes || []).map do |person_type, income|
          age = if person_type == :adult
                  21
                elsif income
                  17
                else
                  11
                end
          {
            date_of_birth: age.years.ago.to_date,
            in_full_time_education: person_type == :child,
            relationship: "#{person_type}_relative",
            assets_value: 0,
          }.tap { _1[:income] = build_income(income) if income }
        end
      end

      def build_income(income)
        {
          frequency: Employment::FREQUENCY_TRANSLATIONS.fetch(income.frequency),
          amount: income.amount,
        }
      end
    end
  end
end

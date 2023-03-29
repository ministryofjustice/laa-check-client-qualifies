class IncomeSection
  class << self
    def all_steps
      %i[employment housing_benefit housing_benefit_details benefits other_income outgoings]
    end

    def steps_for(session_data)
      if NavigationHelper.passported?(session_data) || NavigationHelper.asylum_supported?(session_data)
        []
      else
        employment_steps(session_data) + housing_benefit_steps(session_data) + other_steps
      end
    end

  private

    def employment_steps(session_data)
      NavigationHelper.employed?(session_data) ? [[:employment]] : []
    end

    def other_steps
      %i[benefits other_income outgoings].map { [_1] }
    end

    def housing_benefit_steps(session_data)
      NavigationHelper.housing_benefit?(session_data) ? [%i[housing_benefit housing_benefit_details]] : [%i[housing_benefit]]
    end
  end
end

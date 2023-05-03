class IncomeSection
  class << self
    def all_steps
      %i[employment housing_benefit housing_benefit_details benefits benefit_details other_income outgoings]
    end

    def steps_for(session_data)
      if StepsLogic.passported?(session_data) || StepsLogic.asylum_supported?(session_data)
        []
      else
        employment_steps(session_data) + housing_benefit_steps(session_data) + other_steps(session_data)
      end
    end

  private

    def employment_steps(session_data)
      StepsLogic.employed?(session_data) ? [[:employment]] : []
    end

    def other_steps(session_data)
      benefit_steps(session_data) + %i[other_income outgoings].map { [_1] }
    end

    def benefit_steps(session_data)
      StepsLogic.benefits?(session_data) ? [%i[benefits benefit_details]] : [%i[benefits]]
    end

    def housing_benefit_steps(session_data)
      StepsLogic.housing_benefit?(session_data) ? [%i[housing_benefit housing_benefit_details]] : [%i[housing_benefit]]
    end
  end
end

class PartnerIncomeSection
  class << self
    def all_steps
      %i[partner_employment partner_housing_benefit partner_housing_benefit_details partner_benefits partner_other_income partner_outgoings]
    end

    def steps_for(session_data)
      if StepsLogic.passported?(session_data) || !StepsLogic.partner?(session_data)
        []
      else
        employment_steps(session_data) + housing_benefit_steps(session_data) + other_steps
      end
    end

  private

    def employment_steps(session_data)
      StepsLogic.partner_employed?(session_data) ? [[:partner_employment]] : []
    end

    def other_steps
      %i[partner_benefits partner_other_income partner_outgoings].map { [_1] }
    end

    def housing_benefit_steps(session_data)
      if StepsLogic.partner_housing_benefit?(session_data)
        [%i[partner_housing_benefit partner_housing_benefit_details]]
      else
        [%i[partner_housing_benefit]]
      end
    end
  end
end

module Cfe
  class BaseService
    def self.call(session_data, payload, early_eligibility)
      new(session_data, payload, early_eligibility).call
    end

    def initialize(session_data, payload, early_eligibility)
      @session_data = session_data
      @payload = payload
      @early_eligibility = early_eligibility
    end

  private

    def instantiate_form(form_class)
      form = form_class.from_session(@session_data)
      raise Cfe::InvalidSessionError, form unless form.valid?

      form
    end

    attr_reader :payload

    def check
      @check ||= Check.new(@session_data)
    end

    def relevant_form?(form_name)
      Steps::Helper.valid_step?(@session_data, form_name)
    end

    def early_gross_income_result?
      early_employment_income_result? || early_benefits_income_result? || early_other_income_result?
    end

    def early_partner_gross_income_result?
      early_partner_employment_income_result? || early_partner_benefits_income_result? || early_partner_other_income_result?
    end

    def early_employment_income_result?
      @early_eligibility == :employment_income
    end

    def early_benefits_income_result?
      @early_eligibility == :benefits_income
    end

    def early_other_income_result?
      @early_eligibility == :other_income
    end

    def early_assets_result?
      @early_eligibility == :client_assets
    end

    def early_partner_assets_result?
      @early_eligibility == :partner_assets
    end

    def early_partner_employment_income_result?
      @early_eligibility == :partner_employment_income
    end

    def early_partner_benefits_income_result?
      @early_eligibility == :partner_benefits_income
    end

    def early_partner_other_income_result?
      @early_eligibility == :partner_other_income
    end

    def early_eligibility?
      !@early_eligibility.nil?
    end

    def other_income_invalid?
      !OtherIncomeForm.from_session(@session_data).valid?
    end

    def partner_valid?
      PartnerDetailsForm.from_session(@session_data).valid?
    end

    def partner_other_income_invalid?
      !PartnerOtherIncomeForm.from_session(@session_data).valid?
    end

    def housing_costs_valid?
      HousingCostsForm.from_session(@session_data).valid?
    end

    def partner_assets_valid?
      PartnerAssetsForm.from_session(@session_data).valid?
    end
  end
end

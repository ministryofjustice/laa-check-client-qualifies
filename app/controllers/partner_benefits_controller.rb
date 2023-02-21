class PartnerBenefitsController < BenefitsController
private

  def step_name
    :partner_benefits
  end

  def benefit_session_key
    "partner_benefits"
  end

  def model_class
    PartnerBenefitModel
  end

  def new_path
    new_estimate_partner_benefit_path(assessment_code)
  end
end

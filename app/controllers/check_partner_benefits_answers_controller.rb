class CheckPartnerBenefitsAnswersController < CheckBenefitsAnswersController
private

  def new_path
    new_estimate_check_partner_benefits_answer_path(assessment_code)
  end

  def post_destroy_path
    flow_path(:partner_benefits)
  end

  def step_name
    :partner_benefits
  end

  def benefit_session_key
    "partner_benefits"
  end

  def model_class
    PartnerBenefitModel
  end

  def anchor
    CheckAnswers::SectionIdFinder.call(:partner_benefits)
  end
end

class CheckBenefitsAnswersController < BenefitsController
private

  def flow_path(step)
    estimate_check_answer_path estimate_id, step
  end

  def new_path
    new_estimate_check_benefits_answer_path(estimate_id)
  end

  def next_step_path
    estimate_build_estimate_path estimate_id, :check_answers, anchor: "benefits-section"
  end
end

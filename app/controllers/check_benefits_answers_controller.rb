class CheckBenefitsAnswersController < BenefitsController
private

  def flow_path(step)
    estimate_check_answer_path estimate_id, step
  end

  def new_path
    new_estimate_check_benefits_answer_path(estimate_id)
  end

  def next_step_path(model)
    next_step = next_check_answer_step :benefits, model
    if next_step.present?
      flow_path next_step
    else
      check_answers_estimate_path estimate_id, anchor:
    end
  end

  def post_destroy_path
    flow_path(:benefits)
  end

  def anchor
    "other_income-section"
  end
end

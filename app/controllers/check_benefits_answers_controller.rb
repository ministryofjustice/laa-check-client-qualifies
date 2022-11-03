class CheckBenefitsAnswersController < BenefitsController
  include CheckAnswersFinished

private

  def flow_path(step)
    estimate_check_answer_path estimate_id, step
  end

  def new_path
    new_estimate_check_benefits_answer_path(estimate_id)
  end

  def next_step_path model
    next_step = next_check_answer_step HANDLER_CLASSES, :benefits, model, session_data
    if next_step.present?
      flow_path next_step
    else
      check_answers_estimate_path estimate_id,  anchor: "other_income-section"
    end
  end
end

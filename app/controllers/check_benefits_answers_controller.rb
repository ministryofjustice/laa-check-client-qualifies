class CheckBenefitsAnswersController < BenefitsController
private

  def flow_path(step)
    estimate_check_answer_path assessment_code, step
  end

  def new_path
    new_estimate_check_benefits_answer_path(assessment_code)
  end

  def next_step_path(model)
    next_step = next_check_answer_step :benefits, model
    if next_step.present?
      flow_path next_step
    else
      check_answers_estimate_path assessment_code, anchor:
    end
  end

  def post_destroy_path
    flow_path(:benefits)
  end

  def anchor
    CheckAnswers::SectionIdFinder.call(:benefits)
  end

  def page_name
    "check_#{action_name}_#{step_name}"
  end
end

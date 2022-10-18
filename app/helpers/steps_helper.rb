module StepsHelper
  ALL_POSSIBLE_STEPS = StepListerService.call.map(&:name).freeze

  def next_step_for(estimate, step)
    next_estimate_step(steps_list_for(estimate), step)
  end

  def previous_step_for(estimate, step)
    next_estimate_step(steps_list_for(estimate).reverse, step)
  end

  def end_of_check_answer_loop?(estimate, current_step_name)
    steps = StepListerService.call(estimate)
    current_step = steps.find { _1.name == current_step_name }
    return true if current_step.check_answer_group.nil?

    current_index = steps.index(current_step)

    steps[(current_index + 1)..].none? { _1.check_answer_group == current_step.check_answer_group }
  end

  def last_step_in_group?(estimate, current_step_name)
    end_of_check_answer_loop?(estimate, current_step_name)
  end

private

  def steps_list_for(estimate)
    StepListerService.call(estimate).map(&:name)
  end

  def next_estimate_step(steps, step)
    steps.each_cons(2).detect { |old, _new| old == step }.last
  end
end

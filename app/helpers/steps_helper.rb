module StepsHelper
  FIRST_VEHICLE_STEPS = %i[vehicle vehicle_value].freeze
  REGULAR_USE_VEHICLE_STEPS = %i[vehicle_age vehicle_finance].freeze
  ALL_VEHICLE_STEPS = (FIRST_VEHICLE_STEPS + REGULAR_USE_VEHICLE_STEPS).freeze

  TAIL_STEPS = %i[assets check_answers].freeze

  PASSPORTED_STEPS = %i[property].freeze
  ONLY_PROPERTY_STEPS = %i[property property_entry].freeze

  STEPS_NO_PROPERTY = %i[monthly_income outgoings property].freeze
  STEPS_WITH_PROPERTY = (%i[monthly_income outgoings] + ONLY_PROPERTY_STEPS).freeze

  ALL_POSSIBLE_STEPS = (%i[case_details applicant employment] + STEPS_WITH_PROPERTY + ALL_VEHICLE_STEPS + TAIL_STEPS).freeze

  # codify steps into a readable rule-set table rather than in code
  RULES = {
    passporting: {
      owned: ONLY_PROPERTY_STEPS,
      other: PASSPORTED_STEPS,
    }.freeze,
    other: {
      owned: STEPS_WITH_PROPERTY,
      other: STEPS_NO_PROPERTY,
    }.freeze,
  }.freeze

  VEHICLE_RULES = {
    vehicle_not_owned: %i[vehicle].freeze,
    vehicle_owned: FIRST_VEHICLE_STEPS,
    vehicle_regular: ALL_VEHICLE_STEPS,
  }.freeze

  def next_step_for(intro, step)
    next_estimate_step(steps_list_for(intro).flatten, step)
  end

  # pick the first step in the next section
  def next_section_for(model, step)
    next_section_step(steps_list_for(model), step).first
  end

  def previous_step_for(estimate, step)
    next_estimate_step(steps_list_for(estimate).flatten.reverse, step)
  end

private

  def steps_list_for(estimate)
    pass_key = estimate.passporting ? :passporting : :other
    property_key = estimate.owned? ? :owned : :other
    employment_step = estimate.employed && !estimate.passporting ? [:employment] : []
    non_tail_steps = RULES.fetch(pass_key).fetch(property_key)

    # tail_steps_key = if estimate.vehicle_owned
    #                    if estimate.vehicle_in_regular_use
    #                      :vehicle_regular
    #                    else
    #                      :vehicle_owned
    #                    end
    #                  else
    #                    :vehicle_not_owned
    #                  end

    # vehicle_steps = VEHICLE_RULES.fetch(tail_steps_key)

    if employment_step.empty?
      (%i[case_details applicant].map { |step| [step] } + non_tail_steps.map { |step| [step] } + [ALL_VEHICLE_STEPS] + TAIL_STEPS.map { |step| [step] }).freeze
    else
      (%i[case_details applicant].map { |step| [step] } + [employment_step] + non_tail_steps.map { |step| [step] } + [ALL_VEHICLE_STEPS] + TAIL_STEPS.map { |step| [step] }).freeze
    end
  end

  def next_estimate_step(steps, step)
    steps.each_cons(2).detect { |old, _new| old == step }.last
  end

  def next_section_step(steps, step)
    steps.each_cons(2).detect { |old_list, _new_list| old_list.include?(step) }.last
  end
end

module StepsHelper
  FIRST_VEHICLE_STEPS = %i[vehicle vehicle_value].freeze
  REGULAR_USE_VEHICLE_STEPS = %i[vehicle_age vehicle_finance].freeze
  ALL_VEHICLE_STEPS = (FIRST_VEHICLE_STEPS + REGULAR_USE_VEHICLE_STEPS).freeze

  TAIL_STEPS = %i[assets summary results].freeze

  PASSPORTED_STEPS = %i[property].freeze
  ONLY_PROPERTY_STEPS = %i[property property_entry].freeze

  STEPS_NO_PROPERTY = %i[monthly_income outgoings property].freeze
  STEPS_WITH_PROPERTY = (%i[monthly_income outgoings] + ONLY_PROPERTY_STEPS).freeze

  ALL_POSSIBLE_STEPS = (%i[applicant employment] + STEPS_WITH_PROPERTY + ALL_VEHICLE_STEPS + TAIL_STEPS).freeze

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

  def last_step_in_group?(model, step)
    steps_list = steps_list_for(model).detect { |list| list.include?(step) }
    step == steps_list.last
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

    tail_steps_key = if estimate.vehicle_owned
                       if estimate.vehicle_in_regular_use
                         :vehicle_regular
                       else
                         :vehicle_owned
                       end
                     else
                       :vehicle_not_owned
                     end

    vehicle_steps = VEHICLE_RULES.fetch(tail_steps_key)

    ([%i[applicant]] + [employment_step] + non_tail_steps.map { |step| [step] } + [vehicle_steps] + TAIL_STEPS.map { |step| [step] }).freeze
  end

  def next_estimate_step(steps, step)
    steps.each_cons(2).detect { |old, _new| old == step }.last
  end
end

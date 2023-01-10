module StepsHelper
  TAIL_STEPS = %i[vehicle assets summary results].freeze
  ONLY_PROPERTY_STEPS = %i[property property_entry].freeze

  STEPS_NO_PROPERTY = (%i[monthly_income outgoings property] + TAIL_STEPS).freeze
  STEPS_WITH_PROPERTY = (%i[monthly_income outgoings] + ONLY_PROPERTY_STEPS + TAIL_STEPS).freeze
  PASSPORTED_STEPS = (%i[property] + TAIL_STEPS).freeze
  PASSPORTED_STEPS_WITH_PROPERTY = (ONLY_PROPERTY_STEPS + TAIL_STEPS).freeze
  ALL_STEPS = (%i[applicant employment] + STEPS_WITH_PROPERTY).freeze

  # codify steps into a readable rule-set table rather than in code
  RULES = {
    passporting: {
      owned: PASSPORTED_STEPS_WITH_PROPERTY,
      other: PASSPORTED_STEPS,
    }.freeze,
    other: {
      owned: STEPS_WITH_PROPERTY,
      other: STEPS_NO_PROPERTY,
    }.freeze,
  }.freeze

  def next_step_for(intro, step)
    next_estimate_step(steps_list_for(intro), step)
  end

  def previous_step_for(estimate, step)
    next_estimate_step(steps_list_for(estimate).reverse, step)
  end

private

  def steps_list_for(estimate)
    pass_key = estimate.passporting ? :passporting : :other
    property_key = estimate.owned? ? :owned : :other
    employment_step = estimate.employed && !estimate.passporting ? [:employment] : []
    [:applicant] + employment_step + RULES.fetch(pass_key).fetch(property_key)
  end

  def next_estimate_step(steps, step)
    steps.each_cons(2).detect { |old, _new| old == step }.last
  end
end

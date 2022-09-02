module StepsHelper
  TAIL_STEPS = [:client_vehicle, :assets, :summary, :results].freeze
  ONLY_PROPERTY_STEPS = [:client_property, :property_entry].freeze
  ALL_STEPS = ([:intro, :monthly_income, :outgoings, :client_property] + TAIL_STEPS).freeze
  ALL_STEPS_WITH_PROPERTY = ([:intro, :monthly_income, :outgoings] + ONLY_PROPERTY_STEPS + TAIL_STEPS).freeze
  PASSPORTED_STEPS = ([:intro, :client_property] + TAIL_STEPS).freeze
  PASSPORTED_STEPS_WITH_PROPERTY = ([:intro] + ONLY_PROPERTY_STEPS + TAIL_STEPS).freeze

  # codify steps into a readable rule-set table rather than in code
  RULES = {
    passporting: {
      owned: PASSPORTED_STEPS_WITH_PROPERTY,
      other: PASSPORTED_STEPS
    }.freeze,
    other: {
      owned: ALL_STEPS_WITH_PROPERTY,
      other: ALL_STEPS
    }.freeze
  }.freeze

  def next_step_for(intro, property, step)
    next_estimate_step(steps_list_for(intro, property), step)
  end

  def previous_step_for(estimate, property, step)
    next_estimate_step(steps_list_for(estimate, property).reverse, step)
  end

  private def steps_list_for(estimate, property)
    pass_key = estimate.passporting ? :passporting : :other
    property_key = property&.owned? ? :owned : :other

    RULES.fetch(pass_key).fetch(property_key)
  end

  private def next_estimate_step(steps, step)
    steps.each_cons(2).detect { |old, _new| old == step }.last
  end
end

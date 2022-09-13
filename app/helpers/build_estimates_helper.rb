module BuildEstimatesHelper
  ALL_ESTIMATE_STEPS = [:intro, :monthly_income, :outgoings, :property].freeze
  PASSPORTED_STEPS = [:intro, :property].freeze

  YES_NO_OPTIONS = [
    [I18n.t("generic.yes_choice"), true],
    [I18n.t("generic.no_choice"), false]
  ].freeze

  EMPLOYMENT_OPTIONS = [
    [I18n.t("generic.employed"), true],
    [I18n.t("generic.unemployed"), false]
  ].freeze

  def next_step_for(estimate, step)
    next_estimate_step(steps_list_for(estimate), step)
  end

  def previous_step_for(estimate, step)
    next_estimate_step(steps_list_for(estimate).reverse, step)
  end

  def yes_no_options
    YES_NO_OPTIONS
  end

  def employment_options
    EMPLOYMENT_OPTIONS
  end

  private def steps_list_for(estimate)
    if estimate.passporting
      PASSPORTED_STEPS
    else
      ALL_ESTIMATE_STEPS
    end
  end

  private def next_estimate_step(steps, step)
    steps.each_cons(2).detect { |old, _new| old == step }.last
  end
end

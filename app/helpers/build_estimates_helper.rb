module BuildEstimatesHelper
  ALL_ESTIMATE_STEPS = %i[intro monthly_income outgoings property].freeze
  PASSPORTED_STEPS = %i[intro property].freeze
  POUND = "&pound;".html_safe

  YES_NO_OPTIONS = [
    [true, I18n.t("generic.yes_choice")],
    [false, I18n.t("generic.no_choice")],
  ].freeze

  EMPLOYMENT_OPTIONS = [
    [true, I18n.t("generic.employed")],
    [false, I18n.t("generic.unemployed")],
  ].freeze

  PROPERTY_OPTIONS = [
    [:outright, I18n.t("estimate_flow.property.property_owned.outright")],
    [:with_mortgage, I18n.t("estimate_flow.property.property_owned.with_mortgage")],
    [:none, I18n.t("estimate_flow.property.property_owned.none")],
  ].freeze

  def property_options
    PROPERTY_OPTIONS
  end

  def yes_no_options
    YES_NO_OPTIONS
  end

  def employment_options
    EMPLOYMENT_OPTIONS
  end

  BENEFITS_OPTIONS = {
    1 => I18n.t("estimate_flow.benefit_details.frequency.weekly"),
    2 => I18n.t("estimate_flow.benefit_details.frequency.two_weekly"),
    4 => I18n.t("estimate_flow.benefit_details.frequency.four_weekly"),
  }.freeze

  def benefits_frequencies
    BENEFITS_OPTIONS
  end

  def benefits_options
    benefits_frequencies.map { |k, v| [k, v] }
  end
end

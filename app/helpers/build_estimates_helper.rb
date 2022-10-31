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
    [:with_mortgage, I18n.t("estimate_flow.property.property_owned.with_mortgage")],
    [:outright, I18n.t("estimate_flow.property.property_owned.outright")],
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
end

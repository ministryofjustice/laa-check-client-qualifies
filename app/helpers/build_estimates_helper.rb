module BuildEstimatesHelper
  POUND = "&pound;".html_safe

  YES_NO_OPTIONS = [
    [true, I18n.t("generic.yes_choice")],
    [false, I18n.t("generic.no_choice")],
  ].freeze

  EMPLOYMENT_OPTIONS = [
    ["in_work", I18n.t("generic.in_work")],
    ["receiving_statutory_pay", I18n.t("generic.receiving_statutory_pay")],
    ["unemployed", I18n.t("generic.unemployed")],
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

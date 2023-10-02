module FormsHelper
  POUND = "&pound;".html_safe

  YES_NO_OPTIONS = [
    [true, I18n.t("generic.yes_choice")],
    [false, I18n.t("generic.no_choice")],
  ].freeze

  PROPERTY_OPTIONS = [
    [:with_mortgage, I18n.t("question_flow.property.property_owned.with_mortgage")],
    [:outright, I18n.t("question_flow.property.property_owned.outright")],
    [:none, I18n.t("question_flow.property.property_owned.none")],
  ].freeze

  IMMIGRATION_OR_ASYLUM_TYPE_OPTIONS = [
    [:immigration_clr, I18n.t("question_flow.immigration_or_asylum_type.immigration_clr")],
    [:immigration_legal_help, I18n.t("question_flow.immigration_or_asylum_type.immigration_legal_help")],
    [:asylum, I18n.t("question_flow.immigration_or_asylum_type.asylum")],
  ].freeze

  IMMIGRATION_OR_ASYLUM_TYPE_UPPER_TRIBUNAL_OPTIONS = [
    [:immigration_upper, I18n.t("question_flow.immigration_or_asylum_type_upper_tribunal.immigration_upper")],
    [:asylum_upper, I18n.t("question_flow.immigration_or_asylum_type_upper_tribunal.asylum_upper")],
    [:none, I18n.t("question_flow.immigration_or_asylum_type_upper_tribunal.none")],
  ].freeze

  def property_options
    PROPERTY_OPTIONS
  end

  def yes_no_options
    YES_NO_OPTIONS
  end

  def immigration_or_asylum_type_options
    IMMIGRATION_OR_ASYLUM_TYPE_OPTIONS
  end

  def immigration_or_asylum_type_upper_tribunal_options
    IMMIGRATION_OR_ASYLUM_TYPE_UPPER_TRIBUNAL_OPTIONS
  end

  def document_link(document, sub_section = nil)
    referrer = if %w[forms check_answers].include?(controller_name)
                 Flow::Handler.step_from_url_fragment(params[:step_url_fragment])
               else
                 [controller_name, action_name].join("_")
               end
    document_path(document, sub_section:, assessment_code: params[:assessment_code], referrer:)
  end
end

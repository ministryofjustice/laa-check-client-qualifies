module ApplicationHelper
  def start_button_label(button_label)
    "#{t(".#{button_label}")} ".html_safe << content_tag(:svg,
                                                         content_tag(:path, "", fill: "currentColor", d: "M0 0h13l20 20-20 20H0l20-20z"),
                                                         class: "govuk-button__start-icon",
                                                         xmlns: "http://www.w3.org/2000/svg",
                                                         height: "19",
                                                         viewBox: "0 0 33 40",
                                                         role: "presentation",
                                                         focusable: "false")
  end

  def yes_no_boolean(boolean)
    boolean ? I18n.t("generic.yes_choice") : I18n.t("generic.no_choice")
  end

  def format_money(value)
    number_with_precision(value, precision: 2, delimiter: ",")
  end

  def decimal_as_money_string(form, field)
    current_value = form.object.attributes[field.to_s]
    precision = current_value&.round == current_value ? 0 : 2

    number_with_precision(current_value, precision:, delimiter: ",")
  end
end

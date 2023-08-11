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
    as_money_string(current_value)
  end

  def as_money_string(value)
    return value if value.is_a?(String)

    precision = value&.round == value ? 0 : 2

    number_with_precision(value, precision:, delimiter: ",")
  end

  def integer_field_value(form, field)
    current_value = form.object.attributes[field.to_s]
    return current_value if current_value.is_a?(String)

    number_with_precision(current_value, precision: 0, delimiter: ",")
  end

  def back_link(step, check, mimic_browser_back)
    previous_step = Steps::Helper.previous_step_for(check.session_data, step)

    link = if previous_step
             estimate_build_estimate_path(params[:estimate_id], previous_step)
           else
             provider_users_path
           end
    link_to t("generic.back"), link, class: "govuk-back-link", data: { behaviour: ("browser-back" if mimic_browser_back) }
  end

  def enable_google_analytics(cookies)
    ENV["GOOGLE_TAG_MANAGER_ID"].present? &&
      cookies[CookiesController::COOKIE_CHOICE_NAME] == "accepted" &&
      !cookies[CookiesController::NO_ANALYTICS_MODE]
  end

  def survey_link
    FeatureFlags.enabled?(:public_beta, without_session_data: true) ? t("service.public_beta_survey_link") : t("service.private_beta_survey_link")
  end
end

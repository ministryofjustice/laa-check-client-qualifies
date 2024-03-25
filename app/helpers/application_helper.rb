module ApplicationHelper
  def step_path_from_step(step, assessment_code)
    step_path(step_url_fragment: step_url_fragment_from_step(step), assessment_code:)
  end

  def check_step_path_from_step(step, assessment_code, anchor: nil, begin_editing: nil)
    check_step_path(step_url_fragment: step_url_fragment_from_step(step), assessment_code:, anchor:, begin_editing:)
  end

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

  def back_link(previous_step, mimic_browser_back)
    link = if previous_step
             step_path_from_step(previous_step, params[:assessment_code])
           else
             root_path
           end
    link_to t("generic.back"), link, class: "govuk-back-link", data: { behaviour: ("browser-back" if mimic_browser_back) }
  end

  def enable_google_analytics(cookies)
    ENV["GOOGLE_TAG_MANAGER_ID"].present? &&
      cookies[CookiesController::COOKIE_CHOICE_NAME] == "accepted" &&
      !cookies[CookiesController::NO_ANALYTICS_MODE]
  end

  def using_non_primary_url?
    primary_url = ENV["PRIMARY_HOST"]

    primary_url.present? && request.host != primary_url
  end

  def survey_link
    t("service.public_beta_survey_link")
  end

  def step_url_fragment_from_step(step)
    Flow::Handler.url_fragment(step)
  end

  def timestamp_for_filenames
    Time.zone.now.in_time_zone("London").strftime("%Y-%m-%d %Hh%Mm%Ss")
  end
end

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

  def back_link(step, estimate, mimic_browser_back)
    link = if mimic_browser_back
             "javascript:history.back()"
           elsif (previous_step = StepsHelper.previous_step_for(estimate, step))
             estimate_build_estimate_path(params[:estimate_id], previous_step)
           else
             provider_users_path
           end
    link_to t("generic.back"), link, class: "govuk-back-link"
  end

  def number_to_money(number)
    number_to_currency(number, unit: "£", separator: ".", delimiter: ",", precision: 2)
  end

  def variable_controller_benefit_path(action: nil, id: nil, partner: false)
    prefix = "#{action}_" if action
    main_name = partner ? "partner_benefit" : "benefit"
    controller = controller_name == "check_answers" ? "check_#{main_name}s_answer" : main_name

    if id
      send("#{prefix}estimate_#{controller}_path", params[:estimate_id], id)
    else
      send("#{prefix}estimate_#{controller}s_path", params[:estimate_id])
    end
  end

  def flow_path(estimate_id, step, check_answers: false)
    if check_answers
      estimate_check_answer_path(estimate_id, step)
    else
      estimate_build_estimate_path(estimate_id, step)
    end
  end
end

module BenefitsHelper
  def variable_controller_benefit_path(action: nil, id: nil)
    controller_name = in_check_answer_flow? ? "check_benefits_answer" : "benefit"
    build_benefit_path(controller_name, action, id)
  end

  def variable_controller_partner_benefit_path(action: nil, id: nil)
    controller_name = in_check_answer_flow? ? "check_partner_benefits_answer" : "partner_benefit"
    build_benefit_path(controller_name, action, id)
  end

private

  def build_benefit_path(controller_name, action, id)
    prefix = "#{action}_" if action
    pluralised_name = id ? controller_name : controller_name.pluralize
    send(*["#{prefix}estimate_#{pluralised_name}_path", params[:estimate_id], id].compact)
  end

  def in_check_answer_flow?
    controller_name == "check_answers"
  end
end

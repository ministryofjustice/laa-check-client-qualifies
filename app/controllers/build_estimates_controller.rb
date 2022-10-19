class BuildEstimatesController < EstimateFlowController
  steps :applicant_case_details, :incomes, :capitals, :check_answers

  def show
    case step
    when :applicant_case_details
      redirect_to estimate_build_estimate_applicant_case_details_path estimate_id, :incomes
    when :incomes
      if load_estimate.passporting
        redirect_to estimate_build_estimate_capitals_path estimate_id, :check_answers
      else
        redirect_to estimate_build_estimate_incomes_path estimate_id, :capitals
      end
    when :capitals
      redirect_to estimate_build_estimate_capitals_path estimate_id, :check_answers
    when :check_answers
      redirect_to estimate_check_answer_path estimate_id
    end
  end

  def update
    # handler = HANDLER_CLASSES.fetch(step)
    # @form = handler.form(params, session_data)
    #
    # if @form.valid?
    #   session_data.merge!(@form.attributes)
    #   estimate = load_estimate
    #   handler.save_data(cfe_connection, estimate_id, @form, session_data) if last_step_in_group?(estimate, step)
    #
    #   redirect_to next_wizard_path
    # else
    #   @estimate = load_estimate
    #   render_wizard
    # end
  end
end

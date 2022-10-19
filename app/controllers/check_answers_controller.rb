class CheckAnswersController < ApplicationController
  # steps :applicant_case_details, :incomes, :capitals
  before_action :set_estimate_id

  def show
    @form = EstimateModel.new session_data.slice(*EstimateModel::ESTIMATE_ATTRIBUTES.map(&:to_s))
  end
  # def update
  #   handler = HANDLER_CLASSES.fetch(step)
  #   @form = handler.form(params, session_data)
  #
  #   if @form.valid?
  #     session_data.merge!(@form.attributes)
  #     estimate = load_estimate
  #     if last_step_in_group?(estimate, step)
  #       handler.save_data(cfe_connection, estimate_id, @form, session_data)
  #       redirect_to estimate_build_estimate_path(estimate_id, :check_answers)
  #     else
  #       redirect_to wizard_path next_step_for(estimate, step)
  #     end
  #   else
  #     @estimate = load_estimate
  #     render "estimate_flow/#{step}"
  #   end
  # end

  def estimate_id
    params[:estimate_id]
  end

  private

  def set_estimate_id
    @estimate_id = params[:estimate_id]
  end
end

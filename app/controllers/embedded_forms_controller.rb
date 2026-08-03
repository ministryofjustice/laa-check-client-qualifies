class EmbeddedFormsController < EmbeddedBaseController
  include QuestionFlowMethods   # step, load_check, tag_from, last_tag_in_group?, track_choices
  include FormUpdateMethods     # update action logic (uses mode-aware helpers for redirects)

  def self.local_prefixes
    %w[question_flow] + super
  end

  before_action :load_check

  def show
    track_page_view
    @previous_step = Steps::Helper.previous_step_for(session_data, step)
    @form = Flow::Handler.form_from_session(step, session_data)
    render "/question_flow/#{step}"
  end

  def update
    @previous_step = Steps::Helper.previous_step_for(session_data, step)
    @form = Flow::Handler.model_from_params(step, params, session_data)

    if @form.valid?
      track_choices(@form)
      session_data.merge!(@form.attributes_for_export_to_session)
      next_step = Steps::Helper.next_step_for(session_data, step)
      calculate_early_result
      if Steps::Helper.cannot_use_service?(session_data, step)
        redirect_to cannot_use_service_path(resource_id: params[:resource_id], step:)
      elsif next_step
        redirect_to step_path(step_url_fragment: helpers.step_url_fragment_from_step(next_step), resource_id: params[:resource_id])
      else
        redirect_to check_answers_path(resource_id: params[:resource_id])
      end
    else
      track_validation_error
      render "question_flow/#{step}"
    end
  end
end

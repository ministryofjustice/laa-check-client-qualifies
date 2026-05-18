class EmbeddedFormsController < EmbeddedBaseController
  include QuestionFlowMethods   # step, load_check, tag_from, last_tag_in_group?, track_choices
  include FormUpdateMethods     # update action logic (uses mode-aware helpers for redirects)

  before_action :load_check

  def show
    track_page_view
    @previous_step = Steps::Helper.previous_step_for(session_data, step)
    @form = Flow::Handler.form_from_session(step, session_data)
    render "/question_flow/#{step}"
  end
end

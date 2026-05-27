class EmbeddedChangeAnswersController < EmbeddedBaseController
  include QuestionFlowMethods
  include ChangeAnswersMethods # extracted from ChangeAnswersController

  before_action :load_check
  before_action :set_back_behaviour

  def show
    track_page_view
    @previous_step = Steps::Helper.last_step(session_data)
    @form = Flow::Handler.form_from_session(step, session_data)
    render "/question_flow/#{step}"
  end

  # Override session_data for the pending copy pattern.
  # In standalone mode, ChangeAnswersController stores the pending copy at
  # session[assessment_id][:pending] via direct session access. Here, we store it
  # at @session_data_cache[:pending] — the after_action persists the whole hash to Redis.
  def session_data
    data = @session_data_cache ||= journey_store.read

    if !data[:pending] || params[:begin_editing]
      pending = data.dup
      pending[:pending] = nil
      data[:pending] = pending # mutates @session_data_cache, persisted by after_action
      pending
    else
      data[:pending]
    end
  rescue JourneyDataStore::KeyNotFound
    raise ApplicationController::MissingSessionError
  end

  def save_and_redirect_to_check_answers
    # Promote the pending copy: replace the cached data with the pending version.
    # The after_action will persist this to Redis.
    @session_data_cache = session_data
    redirect_to check_answers_path(resource_id: params[:resource_id], anchor:)
  end
end

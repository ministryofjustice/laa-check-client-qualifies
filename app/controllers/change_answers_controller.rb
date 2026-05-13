class ChangeAnswersController < QuestionFlowController
  include ChangeAnswersMethods

  before_action :set_back_behaviour

private

  def save_and_redirect_to_check_answers
    # Promote the temporary copy of the answers to overwrite the original answers
    session[assessment_id] = session_data
    redirect_to check_answers_path(assessment_code:, anchor:)
  end

  # While we're in a 'change answers loop', we want to be working with a temporary copy of the answers
  # stored in a section of the session called 'pending'.
  def session_data
    data = super

    # Set up a fresh copy of the answers into the pending section if it's blank or we're
    # starting a new loop
    if !data[:pending] || params[:begin_editing]
      pending = data.dup
      pending[:pending] = nil
      session[assessment_id][:pending] = pending
      pending
    else
      data[:pending]
    end
  end
end

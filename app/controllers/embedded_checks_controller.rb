class EmbeddedChecksController < EmbeddedBaseController
  include QuestionFlowMethods

  before_action :clear_early_result, only: :check_answers

  def check_answers
    @check = Check.new(session_data)
    @previous_step = Steps::Helper.last_step(session_data)
    @sections = CheckAnswers::SectionListerService.call(session_data)
    track_page_view(page: :check_answers)
    render "checks/check_answers"
  end

private

  def clear_early_result
    session_data.delete("early_result")
  end
end

class CheckAnswersPresenter
  def initialize(session_data)
    @session_data = session_data
  end

  def sections
    CheckAnswers::SectionListerService.call(@session_data)
  end
end

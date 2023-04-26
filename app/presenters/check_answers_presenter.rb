class CheckAnswersPresenter
  def initialize(session_data)
    @session_data = session_data
  end

  def sections
    CheckAnswers::SectionListerService.call(@session_data)
  end

  def level_of_help
    Check.new(@session_data).level_of_help
  end
end

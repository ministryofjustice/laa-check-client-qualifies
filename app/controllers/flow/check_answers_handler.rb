module Flow
  class CheckAnswersHandler
    class << self
      def model(session_data, _index)
        CheckAnswersPresenter.new(session_data)
      end
    end
  end
end

module Flow
  class CheckAnswersHandler
    class << self
      def show_form(session_data)
        EstimateModel.new(session_data)
      end
    end
  end
end

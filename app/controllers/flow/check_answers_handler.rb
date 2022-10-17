module Flow
  class CheckAnswersHandler
    class << self
      def model(session_data)
        EstimateModel.new session_data.slice(*EstimateModel::ESTIMATE_ATTRIBUTES.map(&:to_s))
      end
    end
  end
end

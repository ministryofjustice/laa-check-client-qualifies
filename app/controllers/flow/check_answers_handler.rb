module Flow
  class CheckAnswersHandler
    class << self
      def model(session_data)
        EstimateModel.new(session_data)
      end

      def form(_params)
        OpenStruct.new(valid?: true, attributes: {})
      end

      def save_data(cfe_connection, estimate_id, _form, session_data)
        estimate = ApplicantHandler.model(session_data)
        cfe_connection.create_applicant estimate_id,
                                        date_of_birth: estimate.over_60 ? 70.years.ago.to_date : 50.years.ago.to_date,
                                        receives_qualifying_benefit: estimate.passporting
      end
    end
  end
end

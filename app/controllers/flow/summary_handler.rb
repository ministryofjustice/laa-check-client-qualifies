module Flow
  class SummaryHandler
    class << self
      def model(session_data); end

      def form(_params)
        OpenStruct.new(valid?: true, attributes: {})
      end

      def save_data(cfe_connection, estimate_id, _form, session_data)
        estimate = EstimateData.new session_data.slice(*EstimateData::ESTIMATE_ATTRIBUTES.map(&:to_s))
        cfe_connection.create_applicant estimate_id,
                                        date_of_birth: estimate.over_60 ? 70.years.ago.to_date : 50.years.ago.to_date,
                                        receives_qualifying_benefit: estimate.passporting
      end
    end
  end
end

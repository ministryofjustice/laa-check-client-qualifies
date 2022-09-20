module Flow
  class SummaryHandler
    class << self
      def model(session_data); end

      def form(_params)
        OpenStruct.new(valid?: true)
      end

      def save_data(cfe_connection, estimate_id, estimate, _session_data); end
    end
  end
end

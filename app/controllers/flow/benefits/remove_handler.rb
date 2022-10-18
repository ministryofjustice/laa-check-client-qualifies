module Flow
  module Benefits
    class RemoveHandler
      class << self
        def form(_params, _session_data, index)
          OpenStruct.new valid?: true, attributes: {}, index:
        end

        def save_data(_cfe_connection, _estimate_id, form, session_data)
          benefits = session_data.fetch("benefits", [])
          benefits.delete_at form.index
          session_data[:benefits] = benefits
        end
      end
    end
  end
end

module Flow
  class DependantsHandler
    class << self
      def model(session_data)
        DependantsForm.new session_data.slice("dependants")
      end

      def form(params, _session_data)
        DependantsForm.new(params.fetch(:dependants_form, {}).permit(:dependants))
      end
    end
  end
end

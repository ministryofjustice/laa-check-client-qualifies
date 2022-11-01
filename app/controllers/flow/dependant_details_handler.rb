module Flow
  class DependantDetailsHandler
    class << self
      def model(session_data)
        DependantDetailsForm.new session_data.slice(*DependantDetailsForm::DEPENDANT_ATTRIBUTES.map(&:to_s))
      end

      def form(params, _session_data)
        DependantDetailsForm.new(params.require(:dependant_details_form).permit(DependantDetailsForm::DEPENDANT_ATTRIBUTES))
      end
    end
  end
end

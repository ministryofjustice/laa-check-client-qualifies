module Flow
  class ApplicantHandler
    class << self
      def model(session_data)
        ApplicantForm.new session_data.slice(*ApplicantForm::INTRO_ATTRIBUTES.map(&:to_s))
      end

      def form(params, _session_data)
        ApplicantForm.new(params.require(:applicant_form).permit(*ApplicantForm::INTRO_ATTRIBUTES))
      end
    end
  end
end

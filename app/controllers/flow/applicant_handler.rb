module Flow
  class ApplicantHandler
    class << self
      def model(session_data)
        ApplicantForm.new(session_data.slice(*ApplicantForm::ATTRIBUTES.map(&:to_s))).tap do |model|
          model.partner = session_data["partner"]
        end
      end

      def form(params, session_data)
        ApplicantForm.new(params.require(:applicant_form).permit(*ApplicantForm::ATTRIBUTES)).tap do |model|
          model.partner = session_data["partner"]
        end
      end
    end
  end
end

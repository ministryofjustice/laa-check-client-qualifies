module Flow
  class PartnerHandler
    class << self
      def model(session_data)
        PartnerForm.new session_data.slice(*PartnerForm::ATTRIBUTES.map(&:to_s))
      end

      def form(params, _session_data)
        PartnerForm.new(params.fetch(:partner_form, {}).permit(*PartnerForm::ATTRIBUTES))
      end
    end
  end
end

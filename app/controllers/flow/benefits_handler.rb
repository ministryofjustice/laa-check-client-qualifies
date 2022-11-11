module Flow
  class BenefitsHandler < GenericHandler
    def modify(form, session_data)
      form.benefits = session_data["benefits"]&.map do |benefits_attributes|
        PartnerBenefitModel.new benefits_attributes.slice(*PartnerBenefitModel::BENEFITS_ATTRIBUTES.map(&:to_s))
      end
    end
  end
end

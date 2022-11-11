module Flow
  class PartnerBenefitsHandler < PartnerHandler
    def modify(form, session_data)
      form.benefits = session_data["partner_benefits"]&.map do |benefits_attributes|
        BenefitModel.new benefits_attributes.slice(*BenefitModel::BENEFITS_ATTRIBUTES.map(&:to_s))
      end
    end
  end
end

class PartnerBenefitsForm < BenefitsForm
  include SessionPersistableForPartner

  def self.from_session(session_data)
    super(session_data).tap { add_benefits(_1, session_data) }
  end

  def self.add_benefits(form, session_data)
    form.benefits = session_data["partner_benefits"]&.map do |benefits_attributes|
      PartnerBenefitModel.from_session(benefits_attributes)
    end
  end
end

module Flow
  class Handler
    CLASSES = {
      level_of_help: LevelOfHelpForm,
      asylum_support: AsylumSupportForm,
      matter_type: MatterTypeForm,
      applicant: ApplicantForm,
      dependant_details: DependantDetailsForm,
      employment: EmploymentForm,
      housing_benefit: HousingBenefitForm,
      housing_benefit_details: HousingBenefitDetailsForm,
      benefits: BenefitsForm,
      other_income: OtherIncomeForm,
      outgoings: OutgoingsForm,
      property: PropertyForm,
      property_entry: ClientPropertyEntryForm,
      vehicle: VehicleForm,
      vehicle_details: VehicleDetailsForm,
      assets: ClientAssetsForm,
      partner_property: PartnerPropertyForm,
      partner_property_entry: PartnerPropertyEntryForm,
      partner_details: PartnerDetailsForm,
      partner_employment: PartnerEmploymentForm,
      partner_housing_benefit: PartnerHousingBenefitForm,
      partner_housing_benefit_details: PartnerHousingBenefitDetailsForm,
      partner_benefits: PartnerBenefitsForm,
      partner_other_income: PartnerOtherIncomeForm,
      partner_outgoings: PartnerOutgoingsForm,
      partner_assets: PartnerAssetsForm,
    }.freeze

    class << self
      def model_from_session(step, session)
        CLASSES.fetch(step).from_session(session)
      end

      def model_from_params(step, params, session)
        CLASSES.fetch(step).from_params(params, session)
      end
    end
  end
end

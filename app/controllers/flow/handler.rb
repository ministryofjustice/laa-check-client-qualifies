module Flow
  class Handler
    CLASSES = {
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
      vehicle_details: ClientVehicleDetailsForm,
      assets: ClientAssetsForm,
      partner_property: PartnerPropertyForm,
      partner_property_entry: PartnerPropertyEntryForm,
      partner_details: PartnerDetailsForm,
      partner_employment: PartnerEmploymentForm,
      partner_benefits: PartnerBenefitsForm,
      partner_other_income: PartnerOtherIncomeForm,
      partner_outgoings: PartnerOutgoingsForm,
      partner_vehicle: PartnerVehicleForm,
      partner_vehicle_details: PartnerVehicleDetailsForm,
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

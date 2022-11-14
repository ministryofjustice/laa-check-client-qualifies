module Flow
  class Handler
    CLASSES = {
      case_details: ProceedingTypeForm,
      partner: PartnerForm,
      applicant: ApplicantForm,
      dependants: DependantsForm,
      dependant_details: DependantDetailsForm,
      employment: EmploymentForm,
      benefits: BenefitsForm,
      other_income: OtherIncomeForm,
      outgoings: OutgoingsForm,
      property: PropertyForm,
      property_entry: PropertyEntryForm,
      vehicle: VehicleForm,
      vehicle_details: ClientVehicleDetailsForm,
      assets: ClientAssetsForm,
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

module Flow
  class Handler
    CLASSES = {
      case_details: { handler_class: GenericHandler, form_class: ProceedingTypeForm },
      partner: { handler_class: GenericHandler, form_class: PartnerForm },
      applicant: { handler_class: ApplicantHandler, form_class: ApplicantForm },
      dependants: { handler_class: GenericHandler, form_class: DependantsForm },
      dependant_details: { handler_class: GenericHandler, form_class: DependantDetailsForm },
      employment: { handler_class: GenericHandler, form_class: EmploymentForm },
      benefits: { handler_class: BenefitsHandler, form_class: BenefitsForm },
      other_income: { handler_class: GenericHandler, form_class: OtherIncomeForm },
      outgoings: { handler_class: GenericHandler, form_class: OutgoingsForm },
      property: { handler_class: GenericHandler, form_class: PropertyForm },
      property_entry: { handler_class: PropertyEntryHandler, form_class: PropertyEntryForm },
      vehicle: { handler_class: GenericHandler, form_class: VehicleForm },
      vehicle_details: { handler_class: GenericHandler, form_class: VehicleDetailsForm },
      assets: { handler_class: AssetHandler, form_class: AssetsForm },
      partner_employment: { handler_class: PartnerHandler, form_class: EmploymentForm },
      partner_benefits: { handler_class: PartnerBenefitsHandler, form_class: BenefitsForm },
      partner_other_income: { handler_class: PartnerHandler, form_class: OtherIncomeForm },
      partner_outgoings: { handler_class: PartnerHandler, form_class: OutgoingsForm },
      partner_vehicle: { handler_class: PartnerHandler, form_class: VehicleForm },
      partner_vehicle_details: { handler_class: PartnerVehicleDetailsHandler, form_class: BaseVehicleDetailsForm },
      partner_assets: { handler_class: PartnerAssetsHandler, form_class: BaseAssetsForm },
    }.freeze

    class << self
      def model_from_session(step, session)
        handler(step).model_from_session(session)
      end

      def model_from_params(step, params, session)
        handler(step).model_from_params(params, session)
      end

      def extract_attributes(step, form)
        handler(step).extract_attributes(form)
      end

      def handler(step)
        classes = CLASSES.fetch(step)
        classes[:handler_class].new(classes[:form_class])
      end
    end
  end
end

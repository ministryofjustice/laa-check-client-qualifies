module Flow
  class Handler
    CLASSES = {
      level_of_help: LevelOfHelpForm,
      asylum_support: AsylumSupportForm,
      matter_type: MatterTypeForm,
      immigration_or_asylum: ImmigrationOrAsylumForm,
      immigration_or_asylum_type: ImmigrationOrAsylumTypeForm,
      applicant: ApplicantForm,
      dependant_details: DependantDetailsForm,
      dependant_income: DependantIncomeForm,
      dependant_income_details: DependantIncomeDetailsForm,
      employment_status: EmploymentStatusForm,
      employment: EmploymentForm,
      income: IncomeForm,
      benefits: BenefitsForm,
      benefit_details: BenefitDetailsForm,
      other_income: OtherIncomeForm,
      outgoings: OutgoingsForm,
      property: PropertyForm,
      property_entry: PropertyEntryForm,
      vehicle: VehicleForm,
      vehicles_details: VehiclesDetailsForm,
      assets: ClientAssetsForm,
      partner_details: PartnerDetailsForm,
      partner_employment_status: PartnerEmploymentStatusForm,
      partner_employment: PartnerEmploymentForm,
      partner_income: PartnerIncomeForm,
      partner_benefits: PartnerBenefitsForm,
      partner_benefit_details: PartnerBenefitDetailsForm,
      partner_other_income: PartnerOtherIncomeForm,
      partner_outgoings: PartnerOutgoingsForm,
      partner_assets: PartnerAssetsForm,
      housing_costs: HousingCostsForm,
      mortgage_or_loan_payment: MortgageOrLoanPaymentForm,
      additional_property: AdditionalPropertyForm,
      additional_property_details: AdditionalPropertyDetailsForm,
      partner_additional_property: PartnerAdditionalPropertyForm,
      partner_additional_property_details: PartnerAdditionalPropertyDetailsForm,
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

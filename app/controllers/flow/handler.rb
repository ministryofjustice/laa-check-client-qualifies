module Flow
  class Handler
    STEPS = {
      level_of_help: { class: LevelOfHelpForm, url_fragment: "what-level-help" },
      asylum_support: { class: AsylumSupportForm, url_fragment: "does-client-get-asylum-support" },
      matter_type: { class: MatterTypeForm, url_fragment: "which-matter-type" },
      immigration_or_asylum: { class: ImmigrationOrAsylumForm, url_fragment: "is-this-immigration-asylum-matter" },
      immigration_or_asylum_type: { class: ImmigrationOrAsylumTypeForm, url_fragment: "immigration-asylum-type" },
      applicant: { class: ApplicantForm, url_fragment: "about-client" },
      dependant_details: { class: DependantDetailsForm, url_fragment: "about-dependants" },
      dependant_income: { class: DependantIncomeForm, url_fragment: "do-dependants-get-income" },
      dependant_income_details: { class: DependantIncomeDetailsForm, url_fragment: "dependant-income-details" },
      employment_status: { class: EmploymentStatusForm, url_fragment: "client-employment-status" },
      income: { class: IncomeForm, url_fragment: "client-employment-income" },
      benefits: { class: BenefitsForm, url_fragment: "does-client-get-benefits" },
      benefit_details: { class: BenefitDetailsForm, url_fragment: "client-benefit-details" },
      other_income: { class: OtherIncomeForm, url_fragment: "client-other-income" },
      outgoings: { class: OutgoingsForm, url_fragment: "client-outgoings" },
      property: { class: PropertyForm, url_fragment: "property-ownership" },
      property_entry: { class: PropertyEntryForm, url_fragment: "home-client-lives-in" },
      vehicle: { class: VehicleForm, url_fragment: "vehicle-ownership" },
      vehicles_details: { class: VehiclesDetailsForm, url_fragment: "vehicle-details" },
      assets: { class: ClientAssetsForm, url_fragment: "client-assets" },
      partner_details: { class: PartnerDetailsForm, url_fragment: "about-partner" },
      partner_employment_status: { class: PartnerEmploymentStatusForm, url_fragment: "partner-employment-status" },
      partner_income: { class: PartnerIncomeForm, url_fragment: "partner-employment-income" },
      partner_benefits: { class: PartnerBenefitsForm, url_fragment: "does-partner-get-benefits" },
      partner_benefit_details: { class: PartnerBenefitDetailsForm, url_fragment: "partner-benefit-details" },
      partner_other_income: { class: PartnerOtherIncomeForm, url_fragment: "partner-other-income" },
      partner_outgoings: { class: PartnerOutgoingsForm, url_fragment: "partner-outgoings" },
      partner_assets: { class: PartnerAssetsForm, url_fragment: "partner-assets" },
      housing_costs: { class: HousingCostsForm, url_fragment: "housing-costs" },
      mortgage_or_loan_payment: { class: MortgageOrLoanPaymentForm, url_fragment: "client-mortgage-loan-payments" },
      additional_property: { class: AdditionalPropertyForm, url_fragment: "does-client-own-other-property-holiday-home-land" },
      additional_property_details: { class: AdditionalPropertyDetailsForm, url_fragment: "client-other-property-holiday-home-land-details" },
      partner_additional_property: { class: PartnerAdditionalPropertyForm, url_fragment: "does-partner-own-other-property-holiday-home-land" },
      partner_additional_property_details: { class: PartnerAdditionalPropertyDetailsForm, url_fragment: "partner-other-property-holiday-home-land-details" },
    }.freeze

    class << self
      def model_from_session(step, session)
        STEPS.fetch(step).fetch(:class).from_session(session)
      end

      def model_from_params(step, params, session)
        STEPS.fetch(step).fetch(:class).from_params(params, session)
      end

      def url_fragment(step)
        STEPS.fetch(step.to_sym).fetch(:url_fragment)
      end

      def step_from_url_fragment(url_fragment)
        STEPS.transform_values { _1[:url_fragment] }.key(url_fragment)
      end
    end
  end
end

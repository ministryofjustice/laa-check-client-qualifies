module CheckAnswers
  class SectionIdFinder
    IDS = {
      level_of_help: "section-level_of_help-header",
      matter_type: "section-about_the_case-header",
      immigration_or_asylum: "section-about_the_case-header",
      immigration_or_asylum_type: "section-about_the_case-header",
      asylum_support: "subsection-asylum_support-header",
      applicant: "section-client_details-header",
      dependant_details: "section-dependants-header",
      employment_status: "subsection-client_employment-header",
      employment: "subsection-client_pay-header",
      income: "subsection-client_employment_income-header",
      benefits: "subsection-benefits-header",
      benefit_details: "subsection-benefits-header",
      other_income: "subsection-other_income-header",
      partner_details: "section-partner_details-header",
      partner_employment_status: "subsection-partner_employment-header",
      partner_employment: "subsection-partner_pay-header",
      partner_income: "subsection-partner_pay-header",
      partner_benefits: "subsection-partner_benefits-header",
      partner_benefit_details: "subsection-partner_benefits-header",
      partner_other_income: "subsection-partner_other_income-header",
      outgoings: "section-outgoings-header",
      partner_outgoings: "section-partner_outgoings-header",
      assets: "section-assets-header",
      partner_assets: "section-partner_assets-header",
      vehicle: "section-household_vehicles-header",
      vehicles_details: "section-household_vehicles-header",
      property: "subsection-property-header",
      property_entry: "subsection-property-header",
      housing_costs: "subsection-housing_costs-header",
      mortgage_or_loan_payment: "subsection-mortgage_or_loan_payment-header",
      additional_property: "subsection-client_additional_property-header",
      additional_property_details: "subsection-client_additional_property-header",
      partner_additional_property: "subsection-partner_additional_property-header",
      partner_additional_property_details: "subsection-partner_additional_property-header",
    }.freeze

    def self.call(step)
      IDS.fetch(step)
    end
  end
end

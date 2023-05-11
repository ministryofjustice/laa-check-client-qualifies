module CheckAnswers
  class SectionIdFinder
    IDS = {
      level_of_help: "section-level_of_help-header",
      matter_type: "section-about_the_case-header",
      tribunal: "subsection-case_details-header",
      asylum_support: "subsection-asylum_support-header",
      applicant: "subsection-client_details-header",
      dependant_details: "subsection-client_dependant_details-header",
      employment: "section-employment-header",
      housing_benefit: "subsection-housing_benefit-header",
      housing_benefit_details: "subsection-housing_benefit-header",
      benefits: "subsection-benefits-header",
      benefit_details: "subsection-benefits-header",
      other_income: "subsection-other_income-header",
      outgoings: "section-outgoings-header",
      property: "subsection-property-header",
      property_entry: "subsection-property-header",
      vehicle: "subsection-vehicles-header",
      vehicle_details: "subsection-vehicles-header",
      vehicles_details: "subsection-vehicles-header",
      assets: "subsection-other-header",
      additional_property: "subsection-other-header",
      additional_property_details: "subsection-other-header",
      partner_details: "subsection-partner_details-header",
      partner_dependant_details: "subsection-partner_dependant_details-header",
      partner_employment: "section-partner_employment-header",
      partner_housing_benefit: "subsection-partner_housing_benefit-header",
      partner_housing_benefit_details: "subsection-partner_housing_benefit-header",
      partner_benefits: "subsection-partner_benefits-header",
      partner_benefit_details: "subsection-partner_benefits-header",
      partner_other_income: "subsection-partner_other_income-header",
      partner_outgoings: "section-partner_outgoings-header",
      partner_property: "subsection-partner_property-header",
      partner_property_entry: "subsection-partner_property-header",
      partner_vehicle: "subsection-partner_vehicles-header",
      partner_vehicle_details: "subsection-partner_vehicles-header",
      partner_assets: "subsection-partner_other-header",
      partner_additional_property: "subsection-partner_other-header",
      partner_additional_property_details: "subsection-partner_other-header",
      housing_costs: "subsection-housing_costs-header",
      mortgage_or_loan_payment: "subsection-mortgage_or_loan_payment-header",
    }.freeze

    def self.call(step)
      # TODO: Modify for household flow
      IDS.fetch(step)
    end
  end
end

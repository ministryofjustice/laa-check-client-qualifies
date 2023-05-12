module CheckAnswers
  class SectionIdFinder
    NON_HOUSEHOLD_FLOW_IDS = {
      level_of_help: "section-level_of_help-header",
      matter_type: "section-about_the_case-header",
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
      assets: "subsection-other-header",
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
    }.freeze

    IDS = {
      level_of_help: "section-level_of_help-header",
      matter_type: "section-about_the_case-header",
      asylum_support: "subsection-asylum_support-header",
      applicant: "section-client_details-header",
      dependant_details: "section-dependants-header",
      employment: "subsection-client_pay-header",
      benefits: "subsection-benefits-header",
      benefit_details: "subsection-benefits-header",
      other_income: "subsection-other_income-header",
      partner_details: "section-partner_details-header",
      partner_dependant_details: "section-dependants-header", # TODO: Remove this in EL-853
      partner_employment: "subsection-partner_pay-header",
      partner_benefits: "subsection-partner_benefits-header",
      partner_benefit_details: "subsection-partner_benefits-header",
      partner_other_income: "subsection-partner_other_income-header",
      outgoings: "section-outgoings-header",
      partner_outgoings: "section-partner_outgoings-header",
      assets: "section-assets-header",
      partner_assets: "section-partner_assets-header",
      vehicle: "section-household_vehicles-header",
      vehicles_details: "section-household_vehicles-header",
      housing_benefit: "subsection-housing_costs-header",
      housing_benefit_details: "subsection-housing_costs-header",
      partner_housing_benefit: "subsection-housing_costs-header", # TODO: Remove this in EL-861
      partner_housing_benefit_details: "subsection-housing_costs-header", # TODO: Remove this in EL-861
      property: "subsection-property-header",
      property_entry: "subsection-property-header",
      additional_property: "subsection-client_additional_property-header",
      additional_property_details: "subsection-client_additional_property-header",
      partner_additional_property: "subsection-partner_additional_property-header",
      partner_additional_property_details: "subsection-partner_additional_property-header",
    }.freeze

    def self.call(step)
      if FeatureFlags.enabled?(:household_section)
        IDS.fetch(step)
      else
        NON_HOUSEHOLD_FLOW_IDS.fetch(step)
      end
    end
  end
end

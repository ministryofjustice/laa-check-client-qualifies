class GuidanceLinkService
  class << self
    def call(document:, sub_section: nil, page_number_only: false)
      feature_flag = FeatureFlags.enabled?(:mtr_phase_1, without_session_data: true) ? :mtr_phase_1_links : :legacy_links

      if page_number_only
        mapping[feature_flag].dig(document, :sections).fetch(sub_section)
      elsif sub_section
        "#{mapping[feature_flag].dig(document, :page_url)}#page=#{mapping[feature_flag].dig(document, :sections).fetch(sub_section)}"
      else
        mapping[feature_flag].dig(document, :page_url)
      end
    end

    def mapping
      {
        legacy_links: {
          mental_heatlh_guidance: {
            page_url: "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/1143984/Mental_Health_Guidance_-_Contract_management_-_GOV.UK_2023.pdf",
          },
          lc_guidance_controlled: {
            page_url: "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/1157029/Lord_Chancellor_s_guide_to_determining_financial_eligibility_for_controlled_work_and_family_mediation_May_2023.pdf",
            sections: {
              legacy_guidance: 3,
              asylum_support: 5,
              passporting_benefit: 5,
              disregarded_payments: 10,
              self_employed: 11,
              dependants_allowance: 15,
              outgoings: 15,
              housing_costs: 16,
              assets: 20,
              properties_guidance: 23,
              additional_properties_guidance: 23,
              smod: 24,
              over_60: 29,
              children: 32,
            },
          },
          lc_guidance_certificated: {
            page_url: "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/1157030/Lord_Chancellor_s_guide_to_determining_financial_eligibility_for_certificated_work_May_2023__002_.pdf",
            sections: {
              passporting_benefit: 11,
              domestic_abuse: 13,
              disregarded_payments: 36,
              outgoings: 38,
              housing_costs: 39,
              dependants_allowance: 42,
              assets: 47,
              vehicle: 55,
              properties_guidance: 57,
              additional_properties_guidance: 58,
              smod: 68,
              capital: 70,
              over_60: 71,
              self_employed: 75,
              bankruptcy: 84,
              business_capital: 86,
              children: 94,
              police: 95,
              prisoner: 96,
              upper_tribunal: 127,
            },
          },
          legislation_CLAR_2013: {
            page_url: "https://www.legislation.gov.uk/uksi/2013/480/contents",
          },
          legislation_CLAR_2013_childcare: {
            page_url: "https://www.legislation.gov.uk/uksi/2013/480/regulation/27",
          },
          legislation_CLAR_2013_housing: {
            page_url: "https://www.legislation.gov.uk/uksi/2013/480/regulation/28",
          },
          legislation_LASPO_2012_immigration: {
            page_url: "https://www.legislation.gov.uk/ukpga/2012/10/schedule/1",
          },
          legislation_ammendments: {
            page_url: "https://www.legislation.gov.uk/all?title=Civil%20Legal%20Aid%20%28Financial%20Resources%20",
          },
          controlled_work_applications: {
            page_url: "https://www.gov.uk/government/collections/controlled-work-application-forms",
          },
          legal_aid_learning: {
            page_url: "https://legalaidlearning.justice.gov.uk/course/view.php?id=186",
          },
        },
        mtr_phase_1_links: {
          mental_heatlh_guidance: {
            page_url: "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/1143984/Mental_Health_Guidance_-_Contract_management_-_GOV.UK_2023.pdf",
          },
          lc_guidance_controlled: {
            page_url: "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/1175062/Lord_Chancellor_s_guide_to_determining_financial_eligibility_for_controlled_work_and_family_mediation__July_2023_.pdf",
            sections: {
              legacy_guidance: 3,
              asylum_support: 7,
              passporting_benefit: 12,
              self_employed: 13,
              disregarded_payments: 15,
              dependants_allowance: 18,
              outgoings: 18,
              housing_costs: 19,
              assets: 22,
              additional_properties_guidance: 25,
              properties_guidance: 25,
              smod: 27,
              over_60: 31,
              children: 34,
            },
          },
          lc_guidance_certificated: {
            page_url: "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/1175064/Lord_Chancellor_s_guide_to_determining_financial_eligibility_for_certificated_work__July_2023_.pdf",
            sections: {
              smod: 8,
              passporting_benefit: 10,
              domestic_abuse: 12,
              outgoings: 34,
              disregarded_payments: 35,
              housing_costs: 38,
              dependants_allowance: 40,
              assets: 44,
              vehicle: 52,
              properties_guidance: 54,
              additional_properties_guidance: 56,
              capital: 66,
              over_60: 68,
              self_employed: 71,
              bankruptcy: 80,
              business_capital: 86,
              children: 88,
              police: 89,
              prisoner: 89,
              upper_tribunal: 110,
            },
          },
          legislation_CLAR_2013: {
            page_url: "https://www.legislation.gov.uk/uksi/2013/480/contents",
          },
          legislation_CLAR_2013_childcare: {
            page_url: "https://www.legislation.gov.uk/uksi/2013/480/regulation/27",
          },
          legislation_CLAR_2013_housing: {
            page_url: "https://www.legislation.gov.uk/uksi/2013/480/regulation/28",
          },
          legislation_LASPO_2012_immigration: {
            page_url: "https://www.legislation.gov.uk/ukpga/2012/10/schedule/1",
          },
          legislation_ammendments: {
            page_url: "https://www.legislation.gov.uk/all?title=Civil%20Legal%20Aid%20%28Financial%20Resources%20",
          },
          controlled_work_applications: {
            page_url: "https://www.gov.uk/government/collections/controlled-work-application-forms",
          },
          legal_aid_learning: {
            page_url: "https://legalaidlearning.justice.gov.uk/course/view.php?id=186",
          },
        },
      }
    end
  end
end

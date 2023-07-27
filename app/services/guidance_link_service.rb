class GuidanceLinkService
  class << self
    def call(document:, chapter: nil, just_the_page_number: false)
      feature_flag = FeatureFlags.enabled?(:mtr_phase_1, without_session_data: true) ? :mtr_phase_1 : :pre_mtr_phase_1

      if just_the_page_number
        mapping[feature_flag].dig(document, :sections, chapter)
      elsif chapter
        mapping[feature_flag].dig(document, :page_url) << "#page=" << mapping[feature_flag].dig(document, :sections, chapter)
      else
        mapping[feature_flag].dig(document, :page_url)
      end
    end

    def mapping
      {
        pre_mtr_phase_1: {
          mental_heatlh_guidance: {
            page_url: "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/1143984/Mental_Health_Guidance_-_Contract_management_-_GOV.UK_2023.pdf",
          },
          lc_guidance_controlled: {
            page_url: "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/1157029/Lord_Chancellor_s_guide_to_determining_financial_eligibility_for_controlled_work_and_family_mediation_May_2023.pdf",
            sections: {
              children: "32",
              legacy_guidance: "3",
              asylum_support: "5",
              over_60: "29",
              dependants_allowance: "15",
              self_employed: "11",
              disregarded_payments: "10",
              outgoings: "15",
              disposable_capital: "20",
              smod: "24",
              property: "23",
              housing_costs: "16",
            },
          },
          lc_guidance_certificated: {
            page_url: "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/1157030/Lord_Chancellor_s_guide_to_determining_financial_eligibility_for_certificated_work_May_2023__002_.pdf",
            sections: {
              children: "94",
              upper_tribunal: "127",
              domestic_abuse: "13",
              passporting_benefit: "11",
              over_60_disregard: "71",
              prisoner: "96",
              dependants_allowance: "42",
              self_employed: "75",
              police: "95",
              disregarded_payments: "36",
              outgoings: "38",
              assets: "47",
              capital: "70",
              bankruptcy: "84",
              smod: "68",
              vehicle: "55",
              property: "57",
              housing_costs: "39",
              additional_property: "58",
            },
          },
          legislation: {
            CLAR_2013: {
              page_url: "https://www.legislation.gov.uk/uksi/2013/480/contents",
            },
            LASPO_2012_immigration: {
              page_url: "https://www.legislation.gov.uk/ukpga/2012/10/schedule/1",
            },
            CLAR_2013_childcare: {
              page_url: "https://www.legislation.gov.uk/uksi/2013/480/regulation/27",
            },
            CLAR_2013_housing: {
              page_url: "https://www.legislation.gov.uk/uksi/2013/480/regulation/28",
            },
          },
          controlled_work_applications: {
            application_forms_on_gov_uk: {
              page_url: "https://www.gov.uk/government/collections/controlled-work-application-forms",
            },
          },
          legal_aid_learning: {
            means_assessments_and_contributions: {
              page_url: "https://legalaidlearning.justice.gov.uk/course/view.php?id=186",
            },
          },
        },
      }
    end
  end
end

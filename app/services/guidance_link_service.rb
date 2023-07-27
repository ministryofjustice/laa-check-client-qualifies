class GuidanceLinkService
  class << self
    def call(document:, chapter: nil, just_the_page_number: false)
      feature_flag = FeatureFlags.enabled?(:mtr_phase_1, without_session_data: true) ? :mtr_phase_1 : :pre_mtr_phase_1

      if just_the_page_number
        mapping[feature_flag].dig(document, :sections, chapter)
      elsif chapter
        mapping[feature_flag].dig(document, :page_url).to_s << "#page=" << mapping[feature_flag].dig(document, :sections, chapter).to_s
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
              legacy_guidance: "3",
              passporting_benefit: "5",
              disregarded_payments: "10",
              self_employed: "11",
              dependants_allowance: "15",
              outgoings: "15",
              housing_costs: "16",
              assets: "20",
              properties_guidance: "23",
              additional_properties_guidance: "23",
              smod: "24",
              over_60: "29",
              children: "32",
            },
          },
          lc_guidance_certificated: {
            page_url: "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/1157030/Lord_Chancellor_s_guide_to_determining_financial_eligibility_for_certificated_work_May_2023__002_.pdf",
            sections: {
              passporting_benefit: "11",
              domestic_abuse: "13",
              disregarded_payments: "36",
              outgoings: "38",
              housing_costs: "39",
              dependants_allowance: "42",
              assets: "47",
              vehicle: "55",
              properties_guidance: "57",
              additional_properties_guidance: "58",
              smod: "68",
              capital: "70",
              over_60: "71",
              self_employed: "75",
              bankruptcy: "84",
              business_capital: "86",
              children: "94",
              police: "95",
              prisoner: "96",
              upper_tribunal: "127",
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

class GuidanceLinkService
  class << self
    def call(document:, section:, just_the_page_number: false)
      feature_flag = FeatureFlags.enabled?(:mtr_phase_1, without_session_data: true) ? :mtr_phase_1 : :pre_mtr_phase_1

      if just_the_page_number
        mapping[feature_flag].dig(document, section, :page_number)
      else
        mapping[feature_flag].dig(document, section, :page_url)
      end
    end

    def mapping
      {
        pre_mtr_phase_1: {
          mental_heatlh_guidance: {
            first_page: {
              page_url: "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/1143984/Mental_Health_Guidance_-_Contract_management_-_GOV.UK_2023.pdf",
              page_number: "1",
            },
          },
          lc_guidance_controlled: {
            children: {
              page_url: "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/1157029/Lord_Chancellor_s_guide_to_determining_financial_eligibility_for_controlled_work_and_family_mediation_May_2023.pdf#page=32",
              page_number: "32",
            },
          },
          lc_guidance_certificated: {
            children: {
              page_url: "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/1157030/Lord_Chancellor_s_guide_to_determining_financial_eligibility_for_certificated_work_May_2023__002_.pdf#page=94",
              page_number: "94",
            },
          },
          legislation: {},
          controlled_work_applications: {},
          legal_aid_learning: {},
        },
      }
    end
  end
end

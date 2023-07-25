class GuidanceLinkService
  class << self
    def call(document, level_of_help, section, page_number = false )
      feature_flag = FeatureFlags.enabled?(:mtr_phase_1, without_session_data: true) ? :mtr_phase_1 : :pre_mtr_phase_1

      level_of_help = level_of_help == "controlled" ? :controlled : :certificated

      attributes[feature_flag].dig(document, level_of_help, section, :page_url)
      page_number ? attributes[feature_flag].dig(document, level_of_help, section, :page_number) : nil
    end

    def attributes
      {
        pre_mtr_phase_1: {
          mental_heatlh_guidance: {
            not_applicable: {
              "First page": {
                page_url: "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/1143984/Mental_Health_Guidance_-_Contract_management_-_GOV.UK_2023.pdf",
                page_number: "1",
              },
            },
          },
          lc_guidance: { 
            controlled: {
              "Eligibility of children": {
                page_url: "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/1157029/Lord_Chancellor_s_guide_to_determining_financial_eligibility_for_controlled_work_and_family_mediation_May_2023.pdf#page=32",
                page_number: "32",
              },
            },
            certificated: {
              "Eligibility of children": {
                page_url: "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/1157030/Lord_Chancellor_s_guide_to_determining_financial_eligibility_for_certificated_work_May_2023__002_.pdf#page=94",
                page_number: "94",
              },
            },
          },
          legislation: { },
          controlled_work_applications: { },
          legal_aid_learning: { },
        },
      }
    end
  end
end

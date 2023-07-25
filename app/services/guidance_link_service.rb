class GuidanceLinkService
  class << self
    def call(document, level_of_help, section, page_number = false)
    # check level_of_help
    # check feature_flag
    # check if page_number needed
    # return correct url and/or page number

      if level_of_help = "controlled"
      end

      if FeatureFlags.enabled?(:mtr_phase_1, without_session_data: true)
      end

      page_url = [document][:level_of_help][section]

      return page_url
    end

    def page_number

    def attributes()
      pre_mtr_phase_1 = {
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
      }
    end
  end
  end
end

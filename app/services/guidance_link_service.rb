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
            first_page: {
              page_url: "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/1157029/Lord_Chancellor_s_guide_to_determining_financial_eligibility_for_controlled_work_and_family_mediation_May_2023.pdf",
              page_number: "1",
            },
            children: {
              page_url: "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/1157029/Lord_Chancellor_s_guide_to_determining_financial_eligibility_for_controlled_work_and_family_mediation_May_2023.pdf#page=32",
              page_number: "32",
            },
            legacy_guidance: {
              page_url: "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/1157029/Lord_Chancellor_s_guide_to_determining_financial_eligibility_for_controlled_work_and_family_mediation_May_2023.pdf#page=3",
              page_number: "3",
            },
            asylum_support: {
              page_url: "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/1157029/Lord_Chancellor_s_guide_to_determining_financial_eligibility_for_controlled_work_and_family_mediation_May_2023.pdf#page=5",
              page_number: "5",
            },
            over_60: {
              page_url: "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/1157029/Lord_Chancellor_s_guide_to_determining_financial_eligibility_for_controlled_work_and_family_mediation_May_2023.pdf#page=29",
              page_number: "29",
            },
            dependants_allowance: {
              page_url: "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/1157029/Lord_Chancellor_s_guide_to_determining_financial_eligibility_for_controlled_work_and_family_mediation_May_2023.pdf#page=15",
              page_number: "15",
            },
            self_employed: {
              page_url: "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/1157029/Lord_Chancellor_s_guide_to_determining_financial_eligibility_for_controlled_work_and_family_mediation_May_2023.pdf#page=11",
              page_number: "11",
            },
            disregarded_payments: {
              page_url: "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/1157029/Lord_Chancellor_s_guide_to_determining_financial_eligibility_for_controlled_work_and_family_mediation_May_2023.pdf#page=10",
              page_number: "10",
            },
            outgoings: {
              page_url: "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/1157029/Lord_Chancellor_s_guide_to_determining_financial_eligibility_for_controlled_work_and_family_mediation_May_2023.pdf#page=15",
              page_number: "15",
            },
            disposable_capital: {
              page_url: "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/1157029/Lord_Chancellor_s_guide_to_determining_financial_eligibility_for_controlled_work_and_family_mediation_May_2023.pdf#page=20",
              page_number: "20",
            },
            smod: {
              page_url: "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/1157029/Lord_Chancellor_s_guide_to_determining_financial_eligibility_for_controlled_work_and_family_mediation_May_2023.pdf#page=24",
              page_number: "24",
            },
            property: {
              page_url: "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/1157029/Lord_Chancellor_s_guide_to_determining_financial_eligibility_for_controlled_work_and_family_mediation_May_2023.pdf#page=23",
              page_number: "23",
            },
            housing_costs: {
              page_url: "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/1157029/Lord_Chancellor_s_guide_to_determining_financial_eligibility_for_controlled_work_and_family_mediation_May_2023.pdf#page=16",
              page_number: "16",
            },
          },
          lc_guidance_certificated: {
            first_page: {
              page_url: "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/1157030/Lord_Chancellor_s_guide_to_determining_financial_eligibility_for_certificated_work_May_2023__002_.pdf",
              page_number: "1",
            },
            children: {
              page_url: "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/1157030/Lord_Chancellor_s_guide_to_determining_financial_eligibility_for_certificated_work_May_2023__002_.pdf#page=94",
              page_number: "94",
            },
            upper_tribunal: {
              page_url: "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/1157030/Lord_Chancellor_s_guide_to_determining_financial_eligibility_for_certificated_work_May_2023__002_.pdf#page=127",
              page_number: "127",
            },
            domestic_abuse: {
              page_url: "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/1157030/Lord_Chancellor_s_guide_to_determining_financial_eligibility_for_certificated_work_May_2023__002_.pdf#page=13",
              page_number: "13",
            },
            passporting_benefit: {
              page_url: "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/1157030/Lord_Chancellor_s_guide_to_determining_financial_eligibility_for_certificated_work_May_2023__002_.pdf#page=11",
              page_number: "11",
            },
            over_60_disregard: {
              page_url: "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/1157030/Lord_Chancellor_s_guide_to_determining_financial_eligibility_for_certificated_work_May_2023__002_.pdf#page=71",
              page_number: "71",
            },
            prisoner: {
              page_url: "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/1157030/Lord_Chancellor_s_guide_to_determining_financial_eligibility_for_certificated_work_May_2023__002_.pdf#page=96",
              page_number: "96",
            },
            dependants_allowance: {
              page_url: "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/1157030/Lord_Chancellor_s_guide_to_determining_financial_eligibility_for_certificated_work_May_2023__002_.pdf#page=42",
              page_number: "42",
            },
            self_employed: {
              page_url: "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/1157030/Lord_Chancellor_s_guide_to_determining_financial_eligibility_for_certificated_work_May_2023__002_.pdf#page=75",
              page_number: "75",
            },
            police: {
              page_url: "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/1157030/Lord_Chancellor_s_guide_to_determining_financial_eligibility_for_certificated_work_May_2023__002_.pdf#page=95",
              page_number: "95",
            },
            disregarded_payments: {
              page_url: "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/1157030/Lord_Chancellor_s_guide_to_determining_financial_eligibility_for_certificated_work_May_2023__002_.pdf#page=36",
              page_number: "36",
            },
            outgoings: {
              page_url: "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/1157030/Lord_Chancellor_s_guide_to_determining_financial_eligibility_for_certificated_work_May_2023__002_.pdf#page=38",
              page_number: "38",
            },
            assets: {
              page_url: "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/1157030/Lord_Chancellor_s_guide_to_determining_financial_eligibility_for_certificated_work_May_2023__002_.pdf#page=47",
              page_number: "47",
            },
            capital: {
              page_url: "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/1157030/Lord_Chancellor_s_guide_to_determining_financial_eligibility_for_certificated_work_May_2023__002_.pdf#page=70",
              page_number: "70",
            },
            bankruptcy: {
              page_url: "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/1157030/Lord_Chancellor_s_guide_to_determining_financial_eligibility_for_certificated_work_May_2023__002_.pdf#page=84",
              page_number: "84",
            },
            smod: {
              page_url: "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/1157030/Lord_Chancellor_s_guide_to_determining_financial_eligibility_for_certificated_work_May_2023__002_.pdf#page=68",
              page_number: "68",
            },
            vehicle: {
              page_url: "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/1157030/Lord_Chancellor_s_guide_to_determining_financial_eligibility_for_certificated_work_May_2023__002_.pdf#page=55",
              page_number: "55",
            },
            property: {
              page_url: "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/1157030/Lord_Chancellor_s_guide_to_determining_financial_eligibility_for_certificated_work_May_2023__002_.pdf#page=57",
              page_number: "57",
            },
            housing_costs: {
              page_url: "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/1157030/Lord_Chancellor_s_guide_to_determining_financial_eligibility_for_certificated_work_May_2023__002_.pdf#page=39",
              page_number: "39",
            },
            additional_property: {
              page_url: "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/1157030/Lord_Chancellor_s_guide_to_determining_financial_eligibility_for_certificated_work_May_2023__002_.pdf#page=58",
              page_number: "58",
            },
          },
          legislation: {
            CLAR_2013: {
              page_url: "https://www.legislation.gov.uk/uksi/2013/480/contents",
              page_number: "contents",
            },
            LASPO_2012_immigration: {
              page_url: "https://www.legislation.gov.uk/ukpga/2012/10/schedule/1",
              page_number: "contents",
            },
            CLAR_2013_childcare: {
              page_url: "https://www.legislation.gov.uk/uksi/2013/480/regulation/27",
              page_number: "contents",
            },
            CLAR_2013_housing: {
              page_url: "https://www.legislation.gov.uk/uksi/2013/480/regulation/28",
              page_number: "contents",
            },
          },
          controlled_work_applications: {
            application_forms_on_gov_uk: {
              page_url: "https://www.gov.uk/government/collections/controlled-work-application-forms",
              page_number: "contents",
            },
          },
          legal_aid_learning: {
            means_assessments_and_contributions: {
              page_url: "https://legalaidlearning.justice.gov.uk/course/view.php?id=186",
              page_number: "contents",
            },
          },
        },
      }
    end
  end
end

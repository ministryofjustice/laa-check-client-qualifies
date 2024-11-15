class ExternalLinkService
  class << self
    def call(document:, sub_section: nil, page_number_only: false)
      external_link_method = FeatureFlags.enabled?(:mtr_accelerated, without_session_data: true) ? external_links : external_links_legacy
      if page_number_only
        external_link_method.dig(document, :sections).fetch(sub_section)
      elsif sub_section
        "#{external_link_method.dig(document, :page_url)}#page=#{external_link_method.dig(document, :sections).fetch(sub_section)}"
      else
        external_link_method.dig(document, :page_url)
      end
    end

  private

    def external_links
      {
        mental_health_guidance: {
          page_url: "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/1143984/Mental_Health_Guidance_-_Contract_management_-_GOV.UK_2023.pdf",
        },
        lc_guidance_controlled: {
          page_url: "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/1176119/Lord_Chancellor_s_guide_to_determining_financial_eligibility_for_controlled_work_and_family_mediation__August_2023_.pdf",
          sections: {
            legacy_guidance: 3,
            under_18: 4,
            asylum_support: 7,
            passporting_benefit: 12,
            income: 13,
            self_employed: 13,
            disregarded_payments: 15,
            dependants_allowance: 22,
            outgoings: 22,
            housing_costs: 23,
            mandatory_discretionary_disreguarded_benefits: 15,
            principles_for_exercising_discretion: 18,
            assets: 26,
            mandatory_discretionary_disreguarded_capital: 26,
            additional_properties_guidance: 36,
            properties_guidance: 36,
            smod: 37,
            equity_disreguard_for_domestic_abuse: 41,
            over_60: 43,
            children: 46,
            means_aggregation: 46,
            child_income: 47,
            child_assets: 47,
          },
        },
        lc_guidance_certificated: {
          page_url: "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/1176073/Lord_Chancellor_s_guide_to_determining_financial_eligibility_for_certificated_work__August_2023_.pdf",
          sections: {
            smod: 8,
            passporting_benefit: 10,
            domestic_abuse: 12,
            under_18: 14,
            income: 23,
            outgoings: 33,
            disregarded_payments: 34,
            mandatory_discretionary_disreguarded_benefits: 34,
            principles_for_exercising_discretion: 37,
            housing_costs: 41,
            dependants_allowance: 43,
            assets: 48,
            vehicle: 56,
            properties_guidance: 58,
            additional_properties_guidance: 60,
            trusts: 65,
            equity_disreguard_for_domestic_abuse: 71,
            capital: 73,
            over_60: 82,
            self_employed: 85,
            business_capital: 86,
            children: 88,
            bankruptcy: 94,
            police: 103,
            prisoner: 103,
            upper_tribunal: 125,
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
        legislation_CLAR_2013_individual_resources: {
          page_url: "https://www.legislation.gov.uk/uksi/2013/480/regulation/16/made",
        },
        legislation_LASPO_2012_immigration: {
          page_url: "https://www.legislation.gov.uk/ukpga/2012/10/schedule/1",
        },
        legislation_cla_2012: {
          page_url: "https://www.legislation.gov.uk/uksi/2012/3098/regulation/21/made",
        },
        legislation_ammendments: {
          page_url: "https://www.legislation.gov.uk/all?title=Civil%20Legal%20Aid%20%28Financial%20Resources%20",
        },
        legal_aid_learning: {
          page_url: "https://legalaidlearning.justice.gov.uk/trapped-capital-practicalities-and-case-studies/",
        },
        legal_aid_checker_for_public: {
          page_url: "https://www.gov.uk/check-legal-aid",
        },
        laa_cw_forms: {
          page_url: "https://www.gov.uk/government/collections/controlled-work-application-forms",
        },
        means_testing_guidance: {
          page_url: "https://www.gov.uk/guidance/civil-legal-aid-means-testing",
        },
      }.with_indifferent_access
    end

    def external_links_legacy
      {
        mental_health_guidance: {
          page_url: "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/1143984/Mental_Health_Guidance_-_Contract_management_-_GOV.UK_2023.pdf",
        },
        lc_guidance_controlled: {
          page_url: "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/1176119/Lord_Chancellor_s_guide_to_determining_financial_eligibility_for_controlled_work_and_family_mediation__August_2023_.pdf",
          sections: {
            legacy_guidance: 3,
            under_18: 4,
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
            means_aggregation: 34,
            child_income: 35,
            child_assets: 35,
          },
        },
        lc_guidance_certificated: {
          page_url: "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/1176073/Lord_Chancellor_s_guide_to_determining_financial_eligibility_for_certificated_work__August_2023_.pdf",
          sections: {
            smod: 8,
            passporting_benefit: 10,
            domestic_abuse: 12,
            under_18: 14,
            outgoings: 34,
            disregarded_payments: 35,
            housing_costs: 38,
            dependants_allowance: 40,
            assets: 44,
            vehicle: 52,
            properties_guidance: 54,
            additional_properties_guidance: 56,
            trusts: 61,
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
        legislation_CLAR_2013_individual_resources: {
          page_url: "https://www.legislation.gov.uk/uksi/2013/480/regulation/16/made",
        },
        legislation_LASPO_2012_immigration: {
          page_url: "https://www.legislation.gov.uk/ukpga/2012/10/schedule/1",
        },
        legislation_cla_2012: {
          page_url: "https://www.legislation.gov.uk/uksi/2012/3098/regulation/21/made",
        },
        legislation_ammendments: {
          page_url: "https://www.legislation.gov.uk/all?title=Civil%20Legal%20Aid%20%28Financial%20Resources%20",
        },
        legal_aid_learning: {
          page_url: "https://legalaidlearning.justice.gov.uk/trapped-capital-practicalities-and-case-studies/",
        },
        legal_aid_checker_for_public: {
          page_url: "https://www.gov.uk/check-legal-aid",
        },
        laa_cw_forms: {
          page_url: "https://www.gov.uk/government/collections/controlled-work-application-forms",
        },
        means_testing_guidance: {
          page_url: "https://www.gov.uk/guidance/civil-legal-aid-means-testing",
        },
      }.with_indifferent_access
    end
  end
end

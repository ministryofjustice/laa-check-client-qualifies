class ExternalLinkService
  class << self
    def call(document:, sub_section: nil, page_number_only: false)
      if page_number_only
        external_links.dig(document, :sections).fetch(sub_section)
      elsif sub_section
        "#{external_links.dig(document, :page_url)}#page=#{external_links.dig(document, :sections).fetch(sub_section)}"
      else
        external_links.dig(document, :page_url)
      end
    end

  private

    def external_links
      {
        mental_health_guidance: {
          page_url: "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/1143984/Mental_Health_Guidance_-_Contract_management_-_GOV.UK_2023.pdf",
        },
        lc_guidance_controlled: {
          page_url: "https://assets.publishing.service.gov.uk/media/684ff44229fb1002010c4e6c/LC_s_guidance_on_determining_financial_eligibility__controlled_and_mediation_.pdf",
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
            mandatory_discretionary_disregarded_benefits: 15,
            principles_for_exercising_discretion_income: 18,
            assets: 26,
            mandatory_discretionary_disregarded_capital: 26,
            principles_for_exercising_discretion_assets: 32,
            additional_properties_guidance: 36,
            properties_guidance: 36,
            smod: 37,
            equity_disregard_for_domestic_abuse: 42,
            over_60: 44,
            means_aggregation: 48,
            child_income: 49,
            child_assets: 49,
            evidence: 54,
          },
        },
        lc_guidance_certificated: {
          page_url: "https://assets.publishing.service.gov.uk/media/684ff4a09d538361ad2da71b/Lord_Chancellor_s_guide_to_determining_financial_eligibility__Certificated_.pdf",
          sections: {
            smod: 8,
            passporting_benefit: 11,
            domestic_abuse: 12,
            under_18: 14,
            income: 23,
            outgoings: 33,
            disregarded_payments: 34,
            mandatory_discretionary_disregarded_benefits: 34,
            principles_for_exercising_discretion_income: 37,
            housing_costs: 41,
            dependants_allowance: 43,
            assets: 48,
            vehicle: 57,
            properties_guidance: 58,
            additional_properties_guidance: 61,
            trusts: 67,
            equity_disregard_for_domestic_abuse: 72,
            mandatory_discretionary_disregarded_capital: 74,
            principles_for_exercising_discretion_assets: 80,
            over_60: 83,
            self_employed: 86,
            business_capital: 87,
            bankruptcy: 95,
            police: 104,
            prisoner: 104,
            upper_tribunal: 126,
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
        controlled_work_form: {
          page_url: "https://www.gov.uk/government/collections/controlled-work-application-forms",
        },
      }.with_indifferent_access
    end
  end
end

class ExternalLinkService
  class << self
    def call(document:, sub_section: nil, page_number_only: false)
      if page_number_only
        mapping[:external_links].dig(document, :sections).fetch(sub_section)
      elsif sub_section
        "#{mapping[:external_links].dig(document, :page_url)}#page=#{mapping[:external_links].dig(document, :sections).fetch(sub_section)}"
      else
        mapping[:external_links].dig(document, :page_url)
      end
    end

    def mapping
      {
        external_links: {
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
          legal_aid_learning: {
            page_url: "https://legalaidlearning.justice.gov.uk/course/view.php?id=186",
          },
          legal_aid_checker_for_public: {
            page_url: "https://www.gov.uk/check-legal-aid",
          },
          laa_cw_forms: {
            page_url: "https://www.gov.uk/government/collections/controlled-work-application-forms",
          },
        },
      }.with_indifferent_access
    end
  end
end

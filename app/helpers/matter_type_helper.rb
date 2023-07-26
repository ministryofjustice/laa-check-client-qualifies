module MatterTypeHelper
  def matter_type_links
    {
      t("estimate_flow.level_of_help.certificated_guidance.text") => t("estimate_flow.level_of_help.certificated_guidance.link",
                                                                       page_url: GuidanceLinkService.call(document: :lc_guidance_certificated, section: :first_page)),
      t("estimate_flow.matter_type.tribunal_guidance.text") => t("estimate_flow.matter_type.tribunal_guidance.certificated_link",
                                                                 page_url: GuidanceLinkService.call(document: :lc_guidance_certificated, section: :upper_tribunal)),
      t("estimate_flow.matter_type.domestic_abuse_guidance.text") => t("estimate_flow.matter_type.domestic_abuse_guidance.link",
                                                                       page_url: GuidanceLinkService.call(document: :lc_guidance_certificated, section: :domestic_abuse)),
    }
  end
end

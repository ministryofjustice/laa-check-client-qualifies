module AsylumSupportHelper
  def asylum_support_links(level_of_help)
    if level_of_help == "controlled"
      {
        t("estimate_flow.asylum_support.guidance.text") => GuidanceLinkService.call(document: :lc_guidance_controlled, sub_section: :asylum_support),
        t("estimate_flow.asylum_support.tribunal_guidance_text") => GuidanceLinkService.call(document: :lc_guidance_controlled),
      }
    else
      {
        t("estimate_flow.asylum_support.guidance.text") => GuidanceLinkService.call(document: :lc_guidance_certificated, sub_section: :upper_tribunal),
      }
    end
  end
end

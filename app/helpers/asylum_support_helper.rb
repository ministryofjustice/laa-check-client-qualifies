module AsylumSupportHelper
  def asylum_support_links(level_of_help)
    if level_of_help == "controlled"
      {
        t("estimate_flow.asylum_support.guidance.text") => document_link(:lc_guidance_controlled, :asylum_support),
        t("estimate_flow.asylum_support.tribunal_guidance_text") => document_link(:lc_guidance_controlled),
      }
    else
      {
        t("estimate_flow.asylum_support.guidance.text") => document_link(:lc_guidance_certificated, :upper_tribunal),
      }
    end
  end
end

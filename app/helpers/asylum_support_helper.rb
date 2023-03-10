module AsylumSupportHelper
  def asylum_support_links(level_of_help)
    if level_of_help == "controlled"
      {
        t("estimate_flow.asylum_support.guidance.text") => t("estimate_flow.asylum_support.guidance.controlled_link"),
        t("estimate_flow.asylum_support.tribunal_guidance_text") => t("estimate_flow.asylum_support.tribunal_guidance_link"),
      }
    else
      {
        t("estimate_flow.asylum_support.guidance.text") => t("estimate_flow.asylum_support.guidance.certificated_link"),
      }
    end
  end
end

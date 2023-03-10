module MatterTypeHelper
  def matter_type_links(level_of_help)
    if level_of_help == "certificated"
      {
        t("estimate_flow.level_of_help.certificated_guidance.text") => t("estimate_flow.level_of_help.certificated_guidance.link"),
        t("estimate_flow.matter_type.tribunal_guidance.text") => t("estimate_flow.matter_type.tribunal_guidance.certificated_link"),
        t("estimate_flow.matter_type.domestic_abuse_guidance.text") => t("estimate_flow.matter_type.domestic_abuse_guidance.link"),
      }
    else
      {
        t("estimate_flow.level_of_help.controlled_guidance.text") => t("estimate_flow.level_of_help.controlled_guidance.link"),
        t("estimate_flow.matter_type.tribunal_guidance.text") => t("estimate_flow.matter_type.tribunal_guidance.controlled_link"),
      }
    end
  end
end

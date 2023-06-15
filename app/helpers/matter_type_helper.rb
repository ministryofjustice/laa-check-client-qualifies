module MatterTypeHelper
  def matter_type_links
    {
      t("estimate_flow.level_of_help.certificated_guidance.text") => t("estimate_flow.level_of_help.certificated_guidance.link"),
      t("estimate_flow.matter_type.tribunal_guidance.text") => t("estimate_flow.matter_type.tribunal_guidance.certificated_link"),
      t("estimate_flow.matter_type.domestic_abuse_guidance.text") => t("estimate_flow.matter_type.domestic_abuse_guidance.link"),
    }
  end
end

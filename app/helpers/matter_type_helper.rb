module MatterTypeHelper
  def matter_type_links(level_of_help)
    links = { t("estimate_flow.matter_type.tribunal_guidance.text") => t("estimate_flow.matter_type.tribunal_guidance.link"), \
              t("estimate_flow.matter_type.domestic_abuse_guidance.text") => t("estimate_flow.matter_type.domestic_abuse_guidance.link") }
    if level_of_help == "certificated"
      links
    else
      {
        t("estimate_flow.matter_type.controlled_guidance_text") => t("estimate_flow.matter_type.controlled_guidance_link"),
      }.merge(links)
    end
  end
end

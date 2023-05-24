module AssetsHelper
  def assets_links(level_of_help, smod_applicable)
    links = {
      t("estimate_flow.assets.guidance.#{level_of_help}.text") => t("estimate_flow.assets.guidance.#{level_of_help}.link"),
      t("estimate_flow.assets.other_property_guidance.text") => t("estimate_flow.assets.other_property_guidance.#{level_of_help}.link"),
    }

    if level_of_help == "certificated"
      links[t("estimate_flow.assets.disregarded_capital_guidance.text")] = t("estimate_flow.assets.disregarded_capital_guidance.link")

      if FeatureFlags.enabled?(:special_applicant_groups)
        links[t("estimate_flow.assets.prisoner_guidance.text")] = t("estimate_flow.assets.prisoner_guidance.link")
        links[t("estimate_flow.assets.bankrupt_guidance.text")] = t("estimate_flow.assets.bankrupt_guidance.link")
      end
    end

    return links unless smod_applicable

    links.merge({ t("generic.smod.guidance.text") => t("generic.smod.guidance.#{level_of_help}.link") })
  end

  def partner_assets_links(check)
    translation_text = check.controlled? ? "controlled" : "certificated"
    links = {
      t("estimate_flow.assets.guidance.#{translation_text}.text") => t("estimate_flow.assets.guidance.#{translation_text}.link"), \
      t("estimate_flow.assets.other_property_guidance.text") => t("estimate_flow.assets.other_property_guidance.#{translation_text}.link"), \
    }

    return links unless FeatureFlags.enabled?(:special_applicant_groups) && !check.controlled?

    links.merge(
      t("estimate_flow.partner_assets.prisoner_guidance.text") => t("estimate_flow.assets.prisoner_guidance.link"),
      t("estimate_flow.partner_assets.bankrupt_guidance.text") => t("estimate_flow.assets.bankrupt_guidance.link"),
    )
  end
end

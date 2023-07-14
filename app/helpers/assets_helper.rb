module AssetsHelper
  def assets_links(check)
    links = {
      t("estimate_flow.assets.guidance.#{check.level_of_help}.text") => t("estimate_flow.assets.guidance.#{check.level_of_help}.link"),
    }

    if check.level_of_help == "certificated"
      links[t("estimate_flow.assets.disregarded_capital_guidance.text")] = t("estimate_flow.assets.disregarded_capital_guidance.link")

      if FeatureFlags.enabled?(:special_applicant_groups, check.session_data)
        links[t("estimate_flow.assets.prisoner_guidance.text")] = t("estimate_flow.assets.prisoner_guidance.link")
        links[t("estimate_flow.assets.bankrupt_guidance.text")] = t("estimate_flow.assets.bankrupt_guidance.link")
      end
    end

    return links unless check.smod_applicable?

    links.merge({ t("generic.smod.guidance.text") => t("generic.smod.guidance.#{check.level_of_help}.link") })
  end

  def partner_assets_links(check)
    links = {
      t("estimate_flow.assets.guidance.#{check.level_of_help}.text") => t("estimate_flow.assets.guidance.#{check.level_of_help}.link"),
    }

    return links unless FeatureFlags.enabled?(:special_applicant_groups, check.session_data) && !check.controlled?

    links.merge(
      t("estimate_flow.partner_assets.prisoner_guidance.text") => t("estimate_flow.assets.prisoner_guidance.link"),
      t("estimate_flow.partner_assets.bankrupt_guidance.text") => t("estimate_flow.assets.bankrupt_guidance.link"),
    )
  end
end

module AssetsHelper
  def assets_links(check)
    links = {
      t("estimate_flow.assets.guidance.#{check.level_of_help}.text") => GuidanceLinkService.call(document: :"lc_guidance_#{check.level_of_help}", chapter: :assets),
    }

    if check.level_of_help == "certificated"
      links[t("estimate_flow.assets.disregarded_capital_guidance.text")] = GuidanceLinkService.call(document: :lc_guidance_certificated, chapter: :capital)
      links[t("estimate_flow.assets.prisoner_guidance.text")] = GuidanceLinkService.call(document: :lc_guidance_certificated, chapter: :prisoner)
      links[t("estimate_flow.assets.bankrupt_guidance.text")] = GuidanceLinkService.call(document: :lc_guidance_certificated, chapter: :bankruptcy)
    end

    return links unless check.smod_applicable?

    links.merge({ t("generic.smod.guidance.text") => GuidanceLinkService.call(document: :"lc_guidance_#{check.level_of_help}", chapter: :smod) })
  end

  def partner_assets_links(check)
    links = {
      t("estimate_flow.assets.guidance.#{check.level_of_help}.text") => GuidanceLinkService.call(document: :"lc_guidance_#{check.level_of_help}", chapter: :assets),
    }

    return links if check.controlled?

    links.merge(
      t("estimate_flow.partner_assets.prisoner_guidance.text") => GuidanceLinkService.call(document: :lc_guidance_certificated, chapter: :prisoner),
      t("estimate_flow.partner_assets.bankrupt_guidance.text") => GuidanceLinkService.call(document: :lc_guidance_certificated, chapter: :bankruptcy),
    )
  end
end

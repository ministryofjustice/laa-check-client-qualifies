module AssetsHelper
  def assets_links(level_of_help, smod_applicable)
    first_links = {
      t("estimate_flow.assets.guidance.#{level_of_help}.text") => t("estimate_flow.assets.guidance.#{level_of_help}.link"),
      t("estimate_flow.assets.other_property_guidance.text") => t("estimate_flow.assets.other_property_guidance.#{level_of_help}.link"),
    }
    links = if level_of_help == "controlled"
              first_links
            else
              first_links.merge({
                t("estimate_flow.assets.disregarded_capital_guidance.text") => t("estimate_flow.assets.disregarded_capital_guidance.certificated.link"),
              })
            end

    return links unless smod_applicable

    links.merge({ t("generic.smod.guidance.text") => t("generic.smod.guidance.#{level_of_help}.link") })
  end
end

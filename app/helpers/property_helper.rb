module PropertyHelper
  def property_links(level_of_help, smod_applicable)
    return non_smod_property_links(level_of_help) unless smod_applicable

    non_smod_property_links(level_of_help).merge({ t("generic.smod.guidance.text") => t("generic.smod.guidance.#{level_of_help}.link") })
  end

  def non_smod_property_links(level_of_help)
    {
      t("estimate_flow.property.properties_guidance.text") => t("estimate_flow.property.properties_guidance.#{level_of_help}.link"),
      t("generic.trapped_capital.text") => t("generic.trapped_capital.#{level_of_help}.link"),
    }
  end
end

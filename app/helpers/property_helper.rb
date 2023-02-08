module PropertyHelper
  def property_links(level_of_help)
    partner_property_links(level_of_help).merge({ t("generic.smod.guidance.text") => t("generic.smod.guidance.#{level_of_help}.link") })
  end

  def partner_property_links(level_of_help)
    {
      t("estimate_flow.property.properties_guidance.text") => t("estimate_flow.property.properties_guidance.#{level_of_help}.link"),
      t("generic.trapped_capital.text") => t("generic.trapped_capital.#{level_of_help}.link"),
    }
  end
end

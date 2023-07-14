module PropertyHelper
  def property_links(level_of_help, smod_applicable, additional_property: false)
    basic = non_smod_property_links(level_of_help, additional_property)
    return basic unless smod_applicable

    basic.merge({ t("generic.smod.guidance.text") => t("generic.smod.guidance.#{level_of_help}.link") })
  end

  def non_smod_property_links(level_of_help, additional_property)
    guidance_type = additional_property ? "additional_properties_guidance" : "properties_guidance"

    {
      t("estimate_flow.property.#{guidance_type}.text") => t("estimate_flow.property.#{guidance_type}.#{level_of_help}.link"),
      t("generic.trapped_capital.text") => t("generic.trapped_capital.#{level_of_help}.link"),
    }
  end
end

module PropertyHelper
  def property_links(level_of_help, smod_applicable, additional_property: false)
    basic = non_smod_property_links(level_of_help, additional_property)
    return basic unless smod_applicable

    basic.merge({ t("generic.smod.guidance.text") => GuidanceLinkService.call(document: :"lc_guidance_#{level_of_help}", sub_section: :smod) })
  end

  def non_smod_property_links(level_of_help, additional_property)
    guidance_type = additional_property ? "additional_properties_guidance" : "properties_guidance"

    {
      t("estimate_flow.property.#{guidance_type}.text") => GuidanceLinkService.call(document: :"lc_guidance_#{level_of_help}", sub_section: :"#{guidance_type}"),
      t("generic.trapped_capital.text") => (level_of_help == "controlled" ? GuidanceLinkService.call(document: :lc_guidance_controlled, sub_section: :assets) : GuidanceLinkService.call(document: :legal_aid_learning)),
    }
  end
end

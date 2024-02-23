module PropertyHelper
  def property_links(level_of_help, smod_applicable, additional_property: false)
    basic = non_smod_property_links(level_of_help, additional_property)
    return basic unless smod_applicable

    basic.merge({ t("generic.smod.guidance.text") => { document: document_link(:"lc_guidance_#{level_of_help}", :smod), file_info: file_info(:"lc_guidance_#{level_of_help}") } })
  end

  def non_smod_property_links(level_of_help, additional_property)
    guidance_type = additional_property ? "additional_properties_guidance" : "properties_guidance"

    {
      t("question_flow.property.#{guidance_type}.#{level_of_help}.text") => { document: document_link(:"lc_guidance_#{level_of_help}", :"#{guidance_type}"), file_info: file_info(:"lc_guidance_#{level_of_help}") },
      t("generic.trapped_capital.text") => (level_of_help == "controlled" ? { document: document_link(:lc_guidance_controlled, :assets), file_info: file_info(:lc_guidance_controlled) } : { document: document_link(:legal_aid_learning), file_info: file_info(:legal_aid_learning) }),
    }
  end
end

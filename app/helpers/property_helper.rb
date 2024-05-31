module PropertyHelper
  def property_links(level_of_help, smod_applicable, additional_property: false)
    basic = non_smod_property_links(level_of_help, additional_property)
    return basic unless smod_applicable

    basic.merge({ t("generic.smod.guidance.#{level_of_help}_text") => document_link(:"lc_guidance_#{level_of_help}", :smod) })
  end

  def non_smod_property_links(level_of_help, additional_property)
    guidance_type = additional_property ? "additional_properties_guidance" : "properties_guidance"

    {
      t("question_flow.property.#{guidance_type}.#{level_of_help}.text") => document_link(:"lc_guidance_#{level_of_help}", :"#{guidance_type}"),
      t("generic.trapped_capital.#{level_of_help}_text") => (level_of_help == "controlled" ? document_link(:lc_guidance_controlled, :assets) : document_link(:legal_aid_learning)),
    }
  end

  def mortgage_or_loan_key
    if FeatureFlags.enabled?(:mtr_accelerated, without_session_data: true)
      "question_flow.mortgage_or_loan_payment.mtr_accelerated"
    else
      "question_flow.mortgage_or_loan_payment.legacy"
    end
  end
end

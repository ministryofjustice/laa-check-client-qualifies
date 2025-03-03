module PropertyHelper
  def property_links(level_of_help, smod_applicable, additional_property: false)
    basic = non_smod_property_links(level_of_help, additional_property)
    return basic unless smod_applicable

    basic.merge({ t("generic.smod.guidance.#{level_of_help}_text") => document_link(:"lc_guidance_#{level_of_help}", :smod) })
  end

  def non_smod_property_links(level_of_help, additional_property)
    guidance_type = additional_property ? "additional_properties_guidance" : "properties_guidance"

    if guidance_type == "properties_guidance"
      {
        t("question_flow.property.#{guidance_type}.#{level_of_help}.text") => document_link(:"lc_guidance_#{level_of_help}", :"#{guidance_type}"),
        t("generic.equity_disregard_for_domestic_abuse.#{level_of_help}_text") => (level_of_help == "controlled" ? document_link(:lc_guidance_controlled, :equity_disreguard_for_domestic_abuse) : document_link(:lc_guidance_certificated, :equity_disreguard_for_domestic_abuse)),
        t("generic.trapped_capital.#{level_of_help}_text") => (level_of_help == "controlled" ? document_link(:lc_guidance_controlled, :assets) : document_link(:legal_aid_learning)),
      }
    else
      {
        t("question_flow.property.#{guidance_type}.#{level_of_help}.text") => document_link(:"lc_guidance_#{level_of_help}", :"#{guidance_type}"),
        t("generic.trapped_capital.#{level_of_help}_text") => (level_of_help == "controlled" ? document_link(:lc_guidance_controlled, :assets) : document_link(:legal_aid_learning)),
      }
    end
  end

  def mortgage_or_loan_key
    "question_flow.mortgage_or_loan_payment"
  end

  def property_entry_key(partner)
    if partner
      "question_flow.property_entry.with_partner"
    else
      "question_flow.property_entry.single"
    end
  end

  def property_hint_content(partner)
    if partner
      lambda { \
        tag.p("", class: "govuk-hint") + \
          govuk_details(summary_text: t("question_flow.property.client_away.hint"), \
                        text: tag.p(t("question_flow.property.client_away.partner_paragraph_1")) + tag.p(t("question_flow.property.client_away.partner_paragraph_2"))) +
          govuk_details(summary_text: t("question_flow.property.partner.prison.title"), \
                        text: t("question_flow.property.partner.prison.hint")) \
      }
    else
      lambda { \
        tag.p("", class: "govuk-hint") + \
          govuk_details(summary_text: t("question_flow.property.client_away.hint"), \
                        text: tag.p(t("question_flow.property.client_away.single_paragraph_1")) + tag.p(t("question_flow.property.client_away.single_paragraph_2"))) \
      }
    end
  end
end

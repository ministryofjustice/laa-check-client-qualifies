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

  def property_entry_key(partner)
    if FeatureFlags.enabled?(:mtr_accelerated, without_session_data: true)
      if partner
        "question_flow.property_entry.mtr_accelerated.with_partner"
      else
        "question_flow.property_entry.mtr_accelerated.single"
      end
    elsif partner
      "question_flow.property_entry.legacy.with_partner"
    else
      "question_flow.property_entry.legacy.single"
    end
  end

  def property_hint_content(partner)
    if partner
      if FeatureFlags.enabled?(:mtr_accelerated, without_session_data: true)
        lambda { \
          tag.p("", class: "govuk-hint") + \
            govuk_details(summary_text: t("question_flow.property.partner.prison.title"), \
                          text: t("question_flow.property.partner.prison.hint")) +
            govuk_details(summary_text: t("question_flow.property.client_away.hint"), \
                          text: t("question_flow.property.client_away.partner")) \
        }
      else
        lambda { \
          tag.p(t("question_flow.property.generic_hint"), class: "govuk-hint") + \
            govuk_details(summary_text: t("question_flow.property.partner.prison.title"), \
                          text: t("question_flow.property.partner.prison.hint")) \
        }
      end
    elsif FeatureFlags.enabled?(:mtr_accelerated, without_session_data: true)
      lambda { \
        tag.p("", class: "govuk-hint") + \
          govuk_details(summary_text: t("question_flow.property.client_away.hint"), \
                        text: t("question_flow.property.client_away.single")) \
      }
    else
      { text: t("question_flow.property.generic_hint") }
    end
  end
end

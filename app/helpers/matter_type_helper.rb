module MatterTypeHelper
  def matter_type_links
    {
      t("question_flow.level_of_help.certificated_guidance.text") => document_link(:lc_guidance_certificated),
      t("question_flow.matter_type.tribunal_guidance.text") => document_link(:lc_guidance_certificated, :upper_tribunal),
      t("question_flow.matter_type.domestic_abuse_guidance.text") => document_link(:lc_guidance_certificated, :domestic_abuse),
    }
  end
end

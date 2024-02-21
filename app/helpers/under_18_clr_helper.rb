module Under18ClrHelper
  def under_18_clr_links
    {
      t("question_flow.under_18_clr.guidance.controlled") => { document: document_link(:lc_guidance_controlled), file_info: file_info(:lc_guidance_controlled) },
      t("question_flow.under_18_clr.guidance.mental_health") => { document: document_link(:mental_health_guidance), file_info: file_info(:mental_health_guidance) },
      t("question_flow.under_18_clr.guidance.clr") => { document: document_link(:lc_guidance_controlled, :under_18), file_info: file_info(:lc_guidance_controlled) },
    }
  end
end

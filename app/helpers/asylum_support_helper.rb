module AsylumSupportHelper
  def asylum_support_links(level_of_help)
    if level_of_help == "controlled"
      {
        t("question_flow.asylum_support.guidance.text") => { document: document_link(:lc_guidance_controlled, :asylum_support), file_info: file_info(:lc_guidance_controlled) },
        t("question_flow.asylum_support.tribunal_guidance_text") => { document: document_link(:lc_guidance_controlled), file_info: file_info(:lc_guidance_controlled) },
      }
    else
      {
        t("question_flow.asylum_support.guidance.text") => { document: document_link(:lc_guidance_certificated, :upper_tribunal), file_info: file_info(:lc_guidance_certificated) },
      }
    end
  end
end

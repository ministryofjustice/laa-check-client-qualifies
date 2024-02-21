module ClientAgeHelper
  def client_age_links
    {
      t("question_flow.client_age.guidance.controlled") => { document: document_link("lc_guidance_controlled"), file_info: file_info(:lc_guidance_controlled) },
      t("question_flow.client_age.guidance.certificated") => { document: document_link("lc_guidance_certificated"), file_info: file_info(:lc_guidance_certificated) },
      t("question_flow.client_age.guidance.under_18_controlled") => { document: document_link("lc_guidance_controlled", :under_18), file_info: file_info(:lc_guidance_controlled) },
      t("question_flow.client_age.guidance.under_18_certificated") => { document: document_link("lc_guidance_certificated", :under_18), file_info: file_info(:lc_guidance_certificated) },
      t("question_flow.client_age.guidance.over_60_controlled") => { document: document_link("lc_guidance_controlled", :over_60), file_info: file_info(:lc_guidance_controlled) },
      t("question_flow.client_age.guidance.over_60_certificated") => { document: document_link("lc_guidance_certificated", :over_60), file_info: file_info(:lc_guidance_certificated) },
    }
  end
end

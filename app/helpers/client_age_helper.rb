module ClientAgeHelper
  def client_age_links
    {
      t("question_flow.client_age.guidance.controlled") => document_link("lc_guidance_controlled"),
      t("question_flow.client_age.guidance.certificated") => document_link("lc_guidance_certificated"),
      t("question_flow.client_age.guidance.under_18_controlled") => document_link("lc_guidance_controlled", :under_18),
      t("question_flow.client_age.guidance.under_18_certificated") => document_link("lc_guidance_certificated", :under_18),
      t("question_flow.client_age.guidance.over_60_controlled") => document_link("lc_guidance_controlled", :over_60),
      t("question_flow.client_age.guidance.over_60_certificated") => document_link("lc_guidance_certificated", :over_60),
    }
  end
end

module Under18ClrHelper
  def under_18_clr_links
    {
      t("question_flow.under_18_clr.guidance.controlled") => document_link("lc_guidance_controlled"),
      t("question_flow.under_18_clr.guidance.mental_health") => document_link("mental_health_guidance"),
      t("question_flow.under_18_clr.guidance.clr") => document_link("lc_guidance_controlled", :under_18),
    }
  end
end

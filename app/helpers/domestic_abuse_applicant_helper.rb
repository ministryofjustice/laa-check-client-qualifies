module DomesticAbuseApplicantHelper
  def domestic_abuse_applicant_links
    {
      t("question_flow.level_of_help.certificated_guidance.text") => document_link(:lc_guidance_certificated),
      t("question_flow.matter_type.domestic_abuse_guidance.text") => document_link(:lc_guidance_certificated, :domestic_abuse),
    }
  end
end

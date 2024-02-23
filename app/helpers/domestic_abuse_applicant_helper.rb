module DomesticAbuseApplicantHelper
  def domestic_abuse_applicant_links
    {
      t("question_flow.level_of_help.certificated_guidance.text") => { document: document_link(:lc_guidance_certificated), file_info: file_info(:lc_guidance_certificated) },
      t("question_flow.domestic_abuse_applicant.domestic_abuse_guidance.text") => { document: document_link(:lc_guidance_certificated, :domestic_abuse), file_info: file_info(:lc_guidance_certificated) },
    }
  end
end

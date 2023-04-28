module ApplicantHelper
  def applicant_links(check)
    {
      t("estimate_flow.applicant.passporting_guidance.text") => t("estimate_flow.applicant.passporting_guidance.#{check.level_of_help}.link"),
      t("estimate_flow.applicant.pensioner_guidance.text") => t("estimate_flow.applicant.pensioner_guidance.#{check.level_of_help}.link"),
    }
  end
end

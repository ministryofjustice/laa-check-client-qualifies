module ApplicantHelper
  def applicant_links(level_of_help)
    {
      t("estimate_flow.applicant.passporting_guidance.text") => t("estimate_flow.applicant.passporting_guidance.#{level_of_help}.link"),
      t("estimate_flow.applicant.pensioner_guidance.text") => t("estimate_flow.applicant.pensioner_guidance.#{level_of_help}.link"),
    }
  end
end

module ApplicantHelper
  def applicant_links(level_of_help)
    links = {
      t("estimate_flow.applicant.passporting_guidance.text") => t("estimate_flow.applicant.passporting_guidance.#{level_of_help}.link"),
      t("estimate_flow.applicant.pensioner_guidance.text") => t("estimate_flow.applicant.pensioner_guidance.#{level_of_help}.link"),
    }
    if !FeatureFlags.enabled?(:asylum_and_immigration) && level_of_help != "controlled"
      links
    else
      links.merge({
        t("estimate_flow.applicant.domestic_abuse_guidance.text") => t("estimate_flow.applicant.domestic_abuse_guidance.link"),
      })
    end
  end
end

module ApplicantHelper
  def applicant_links(check)
    links = {
      t("estimate_flow.applicant.passporting_guidance.text") => t("estimate_flow.applicant.passporting_guidance.#{check.level_of_help}.link"),
      t("estimate_flow.applicant.pensioner_guidance.text") => t("estimate_flow.applicant.pensioner_guidance.#{check.level_of_help}.link"),
    }

    return links if check.controlled?

    links.merge(
      t("estimate_flow.applicant.prisoner_guidance.text") => t("estimate_flow.applicant.prisoner_guidance.link"),
    )
  end
end

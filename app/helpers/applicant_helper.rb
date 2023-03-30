module ApplicantHelper
  def applicant_links(check)
    links = {
      t("estimate_flow.applicant.passporting_guidance.text") => t("estimate_flow.applicant.passporting_guidance.#{check.level_of_help}.link"),
      t("estimate_flow.applicant.pensioner_guidance.text") => t("estimate_flow.applicant.pensioner_guidance.#{check.level_of_help}.link"),
    }
    if check.use_legacy_proceeding_type?
      links.merge({
        t("estimate_flow.applicant.domestic_abuse_guidance.text") => t("estimate_flow.applicant.domestic_abuse_guidance.link"),
      })
    else
      links
    end
  end
end

module ApplicantHelper
  def applicant_links(check)
    links = {
      t("estimate_flow.applicant.passporting_guidance.text") => GuidanceLinkService.call(document: :"lc_guidance_#{check.level_of_help}", sub_section: :passporting_benefit),
      t("estimate_flow.applicant.pensioner_guidance.text") => GuidanceLinkService.call(document: :"lc_guidance_#{check.level_of_help}", sub_section: :over_60),
    }

    return links if check.controlled?

    links.merge(
      t("estimate_flow.applicant.prisoner_guidance.text") => GuidanceLinkService.call(document: :lc_guidance_certificated, sub_section: :prisoner),
    )
  end
end

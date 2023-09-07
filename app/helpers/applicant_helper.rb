module ApplicantHelper
  def applicant_links(check)
    links = {
      t("question_flow.applicant.passporting_guidance.text") => document_link("lc_guidance_#{check.level_of_help}", :passporting_benefit),
      t("question_flow.applicant.pensioner_guidance.text") => document_link("lc_guidance_#{check.level_of_help}", :over_60),
    }

    return links if check.controlled?

    links.merge(
      t("question_flow.applicant.prisoner_guidance.text") => document_link(:lc_guidance_certificated, :prisoner),
    )
  end
end

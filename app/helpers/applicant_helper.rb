module ApplicantHelper
  def applicant_links(check)
    links = {
      t("question_flow.applicant.passporting_guidance.text") => { document: document_link(:"lc_guidance_#{check.level_of_help}", :passporting_benefit), file_info: file_info(:lc_guidance_certificated) },
    }

    return links if check.controlled?

    links.merge(
      t("question_flow.applicant.prisoner_guidance.text") => { document: document_link(:lc_guidance_certificated, :prisoner), file_info: file_info(:lc_guidance_certificated) },
    )
  end
end

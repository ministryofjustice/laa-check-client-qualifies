class SubmitProceedingsService < BaseCfeService
  def call(cfe_assessment_id)
    applicant_form = ApplicantForm.from_session(@session_data)
    proceeding_type = if applicant_form.level_of_help != "controlled" && !FeatureFlags.enabled?(:asylum_and_immigration)
                        applicant_form.legacy_proceeding_type
                      elsif FeatureFlags.enabled?(:asylum_and_immigration)
                        matter_type_form = MatterTypeForm.from_session(@session_data)
                        matter_type_form.proceeding_type
                      else
                        ApplicantForm::PROCEEDING_TYPES[:other]
                      end
    cfe_connection.create_proceeding_type(cfe_assessment_id, proceeding_type)
  end
end

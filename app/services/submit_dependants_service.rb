class SubmitDependantsService < BaseCfeService
  def call(cfe_estimate_id, cfe_session_data)
    form = ApplicantForm.from_session(cfe_session_data)
    return unless form.dependants

    details_form = DependantDetailsForm.from_session(cfe_session_data)
    all_dependants = CfeParamBuilders::Dependants.call(details_form)

    cfe_connection.create_dependants(cfe_estimate_id, all_dependants) if all_dependants.any?
  end
end

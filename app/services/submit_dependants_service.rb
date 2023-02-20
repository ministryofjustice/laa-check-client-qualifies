class SubmitDependantsService < BaseCfeService
  def call(cfe_assessment_id, session_data)
    details_form = DependantDetailsForm.from_session(session_data)
    children = CfeParamBuilders::Dependants.children(dependants: details_form.child_dependants,
                                                     count: details_form.child_dependants_count)
    adults = CfeParamBuilders::Dependants.adults(dependants: details_form.adult_dependants,
                                                 count: details_form.adult_dependants_count)
    dependants = children + adults
    cfe_connection.create_dependants(cfe_assessment_id, dependants) if dependants.any?
  end
end

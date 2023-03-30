def session_contents
  page.get_rack_session.values.last
end

def set_session(assessment_code, session_contents)
  visit estimate_build_estimate_path(assessment_code, :level_of_help)
  click_on "Reject additional cookies" # This triggers a session cookie ID to be set in the test environment
  session = page.get_rack_session
  session[session.keys.last] = session_contents
  page.set_rack_session(session)
end

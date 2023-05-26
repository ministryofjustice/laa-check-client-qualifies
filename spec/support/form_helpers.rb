def session_contents
  page.get_rack_session.values.last
end

def set_session(assessment_code, session_contents)
  visit root_path
  cookie_header = page.response_headers["Set-Cookie"]
  # cookie_header is of format "SessionData=UUID; path=/; HttpOnly; SameSite=Lax"
  session_key = cookie_header.split(";").first.split("=").last
  key = Digest::SHA256.hexdigest(assessment_code.to_s + session_key)
  session = page.get_rack_session
  session[key] = session_contents
  page.set_rack_session(session)
end

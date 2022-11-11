module Flow
  class ApplicantHandler < GenericHandler
    def modify(form, session_data)
      form.partner = session_data["partner"]
    end
  end
end

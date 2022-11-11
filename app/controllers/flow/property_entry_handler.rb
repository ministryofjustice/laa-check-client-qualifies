module Flow
  class PropertyEntryHandler < GenericHandler
    def modify(form, session_data)
      form.property_owned = session_data["property_owned"]
    end
  end
end

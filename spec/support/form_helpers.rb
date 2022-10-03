def select_applicant_boolean(field, value)
  select_boolean_value("applicant-form", field, value)
end

def select_boolean_value(form_name, field, value)
  fieldname = field.to_s.tr("_", "-")
  if value
    find("label[for=#{form_name}-#{fieldname}-true-field]").click
  else
    find("label[for=#{form_name}-#{fieldname}-field]").click
  end
end

def click_checkbox(form_name, field)
  fieldname = field.to_s.tr("_", "-")
  find("label[for=#{form_name}-#{fieldname}-field]").click
end

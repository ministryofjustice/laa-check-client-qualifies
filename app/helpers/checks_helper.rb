module ChecksHelper
  def check_answers_field_key(field)
    "checks.check_answers.#{field.label}"
  end

  def check_answers_table_key(table)
    "checks.check_answers.tables.#{table.screen}"
  end
end

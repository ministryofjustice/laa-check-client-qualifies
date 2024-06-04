module ChecksHelper
  def check_answers_field_key(field)
    new_old = if FeatureFlags.enabled?(:mtr_accelerated, without_session_data: true)
                "checks.check_answers.#{field.label}.mtr_accelerated"
              else
                "checks.check_answers.#{field.label}.legacy"
              end
    if I18n.exists?(new_old, :en)
      new_old
    else
      "checks.check_answers.#{field.label}"
    end
  end

  def check_answers_table_key(table)
    new_old = if FeatureFlags.enabled?(:mtr_accelerated, without_session_data: true)
                "checks.check_answers.tables.#{table.screen}.mtr_accelerated"
              else
                "checks.check_answers.tables.#{table.screen}.legacy"
              end
    if I18n.exists?(new_old, :en)
      new_old
    else
      "checks.check_answers.tables.#{table.screen}"
    end
  end
end

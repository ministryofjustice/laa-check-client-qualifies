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
end

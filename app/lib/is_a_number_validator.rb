class IsANumberValidator < ActiveModel::EachValidator
  # For the custom types defined in config/initializers/attribute_types.rb,
  # we will cast any values we recognise as numbers as numbers.
  # Any numbers we don't recognise will be left as strings so that the user can
  # be shown exactly what they entered in the relevant field alongside the validation message.
  # This big of logic notices any time a number has not been recognised, and ensures
  # an appropriate validation message is shown.
  def validate_each(record, attribute, value)
    record.errors.add(attribute, :not_a_number) if value.is_a?(String)
  end
end

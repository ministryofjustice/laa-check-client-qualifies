module NumberValidatable
  extend ActiveSupport::Concern
  include ActiveModel::Validations

  included do
    validate :numbers_are_all_valid
  end

  def numbers_are_all_valid
    self.class.attribute_types.each do |attribute, attribute_type|
      next unless attribute_type.is_a?(Gbp) || attribute_type.is_a?(FullyValidatableInteger)

      # For the custom types defined in config/initializers/attribute_types.rb,
      # we will cast any values we recognise as numbers as numbers.
      # Any numbers we don't recognise will be left as strings so that the user can
      # be shown exactly what they entered in the relevant field alongside the validation message.
      # This big of logic notices any time a number has not been recognised, and ensures
      # an appropriate validation message is shown.
      errors.add(attribute.to_sym, :not_a_number) if attributes[attribute].is_a?(String)
    end
  end
end

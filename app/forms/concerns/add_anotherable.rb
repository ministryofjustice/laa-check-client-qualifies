# This module allows a model object to populate itself from a session object with or without some params,
# and also to translate its values into attributes to go into the session.
module AddAnotherable
  extend ActiveSupport::Concern
  include ActionView::Helpers::TagHelper

  included do
    attr_accessor :items

    validate :items_valid?
  end

  class_methods do
    # Override SessionPersistable to additionally instantiate `items`
    def from_session(session_data)
      form = instantiate_with_simple_attributes_from_session(session_data)

      form.items = session_data[self::ITEMS_SESSION_KEY]&.each_with_index&.map do |attributes, index|
        self::ITEM_MODEL.from_session(attributes).tap { add_extra_attributes_to_model_from_session(_1, session_data, index) }
      end

      if form.items.blank?
        form.items = [form.blank_model]
      end
      form
    end

    # Override SessionPersistable to additionally instantiate `items`
    def from_params(params, session_data)
      form = instantiate_with_simple_attributes_from_params(params, session_data)
      form.items = params.dig(param_key, "items").values.each_with_index.map do |attributes, index|
        self::ITEM_MODEL.from_session(attributes).tap { add_extra_attributes_to_model_from_session(_1, session_data, index) }
      end
      form
    end

    def param_key
      self::ITEM_MODEL.name.underscore
    end

    def add_extra_attributes_to_model_from_session(*)
      # This is left blank in the base class as an optional hook for subclasses
    end
  end

  def attributes_for_export_to_session
    simple_attributes_for_session.merge(self.class::ITEMS_SESSION_KEY => items.map(&:attributes_for_export_to_session))
  end

  def blank_model
    self.class::ITEM_MODEL.new.tap { self.class.add_extra_attributes_to_model_from_session(_1, check.session_data, 0) }
  end

private

  def items_valid?
    return if items.all?(&:valid?)

    # Note that the `all` iterator above will terminate the first time it finds an invalid item.
    # This is deliberate: we want users to be prompted to deal with errors one item at a time.

    items.each_with_index do |item, index|
      item.errors.each do |error|
        errors.add(:"items_#{index + 1}_#{error.attribute}", error_message(error, items.length, item.class, index + 1))
      end
    end
  end

  def error_message(error, number_of_items, model_class, position)
    key = "activemodel.errors.models.#{model_class.to_s.underscore}.attributes.#{error.attribute}.#{error.type}"
    if number_of_items > 1
      position_tag = tag.span(position, data: { add_another_role: "errorPosition" })
      content = I18n.t("#{key}_when_many",
                       position: position_tag)
      tag.span(content.html_safe, data: { add_another_role: "errorMessage", add_another_item_position: position })
    else
      I18n.t(key)
    end
  end
end

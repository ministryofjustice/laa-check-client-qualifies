# This module allows a model object to populate itself from a session object with or without some params,
# and also to translate its values into attributes to go into the session.
module AddAnotherable
  extend ActiveSupport::Concern

  included do
    attr_accessor :items

    validate :items_valid?
  end

  class_methods do
    # Override SessionPersistable to additionally instantiate `items`
    def from_session(session_data)
      form = instantiate_with_simple_attributes_from_session(session_data)

      form.items = session_data[self::ITEMS_SESSION_KEY]&.map do |attributes|
        self::ITEM_MODEL.from_session(attributes).tap { add_extra_attributes_to_model_from_session(_1, session_data) }
      end

      if form.items.blank?
        form.items = [form.blank_model]
      end
      form
    end

    # Override SessionPersistable to additionally instantiate `items`
    def from_params(params, session_data)
      form = instantiate_with_simple_attributes_from_params(params, session_data)
      form.items = params.dig(self::ITEM_MODEL.name.underscore, "items").values.map do |attributes|
        self::ITEM_MODEL.from_session(attributes).tap { add_extra_attributes_to_model_from_session(_1, session_data) }
      end
      form
    end

    def add_extra_attributes_to_model_from_session(*)
      # This is left blank in the base class as an optional hook for subclasses
    end
  end

  def attributes_for_export_to_session
    simple_attributes_for_session.merge(self.class::ITEMS_SESSION_KEY => items.map(&:attributes_for_export_to_session))
  end

  def blank_model
    self.class::ITEM_MODEL.new.tap { self.class.add_extra_attributes_to_model_from_session(_1, check.session_data) }
  end

private

  def items_valid?
    return if items.all?(&:valid?)

    items.each_with_index do |item, index|
      item.errors.messages.each do |field, messages|
        errors.add(:"items_#{index + 1}_#{field}", messages.first)
      end
    end
  end
end

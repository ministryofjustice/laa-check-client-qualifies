class BaseAddAnotherForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attr_accessor :items

  PREFIX = nil

  # Children must define ITEM_MODEL, ADD_ANOTHER_ATTRIBUTES and SESSION_KEY constants
  SESSION_KEY = nil
  ITEM_MODEL = nil
  ADD_ANOTHER_ATTRIBUTES = nil

  validate :items_valid?

  class << self
    def from_session(session_data)
      form = new
      form.items = session_data[self::SESSION_KEY]&.map do |attributes|
        self::ITEM_MODEL.from_session(attributes).tap { add_session_attributes(_1, session_data) }
      end

      if form.items.blank?
        form.items = [self::ITEM_MODEL.new.tap { add_session_attributes(_1, session_data) }]
      end
      form
    end

    def from_params(params, session_data)
      form = new
      form.items = params.dig(self::ITEM_MODEL.name.underscore, "items").values.map do |attributes|
        self::ITEM_MODEL.from_session(attributes).tap { add_session_attributes(_1, session_data) }
      end
      form
    end

    def add_session_attributes(*)
      # This is left blank in the base class as an optional hook for subclasses
    end

    def session_keys
      [self::SESSION_KEY]
    end
  end

  def session_attributes
    { self.class::SESSION_KEY => items.map(&:session_attributes) }
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

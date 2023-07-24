class AdditionalPropertyDetailsForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include SessionPersistable
  include AddAnotherable

  ITEMS_SESSION_KEY = "additional_properties".freeze
  ITEM_MODEL = AdditionalPropertyModel
  ATTRIBUTES = %i[additional_properties].freeze
  alias_attribute :additional_properties, :items

  class << self
    def add_extra_attributes_to_model_from_session(model, session_data, index)
      check = Check.new(session_data)
      model.smod_applicable = check.smod_applicable?
      model.ownership_status = check.additional_property_owned if index.zero?
    end
  end

  # Note that unlike a normal blank model, we pass an index of 1 here.
  def blank_additional_model
    self.class::ITEM_MODEL.new.tap { self.class.add_extra_attributes_to_model_from_session(_1, check.session_data, 1) }
  end
end

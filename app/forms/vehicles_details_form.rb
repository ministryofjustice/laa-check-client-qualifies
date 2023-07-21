class VehiclesDetailsForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include SessionPersistable
  include AddAnotherable

  ITEMS_SESSION_KEY = "vehicles".freeze
  ITEM_MODEL = VehicleModel
  ATTRIBUTES = %i[vehicles].freeze
  alias_attribute :vehicles, :items

  class << self
    def add_extra_attributes_to_model_from_session(vehicle_model, session_data, _)
      check = Check.new(session_data)
      vehicle_model.smod_applicable = check.smod_applicable?
    end
  end
end

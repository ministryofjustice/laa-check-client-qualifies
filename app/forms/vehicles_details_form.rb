class VehiclesDetailsForm < BaseAddAnotherForm
  SESSION_KEY = "vehicles".freeze
  ITEM_MODEL = VehicleModel
  ATTRIBUTES = %i[vehicles].freeze
  alias_attribute :vehicles, :items

  class << self
    def add_session_attributes(vehicle_model, session_data)
      check = Check.new(session_data)
      vehicle_model.smod_applicable = check.smod_applicable?
    end
  end
end

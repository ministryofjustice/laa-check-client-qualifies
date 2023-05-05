class VehiclesDetailsForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attr_accessor :vehicles

  ATTRIBUTES = %i[vehicles].freeze

  SESSION_KEY = "vehicles".freeze

  validate :vehicles_valid?

  class << self
    def from_session(session_data)
      form = new
      form.vehicles = session_data[self::SESSION_KEY]&.map do |attributes|
        assign_smod_applicability(VehicleModel.from_session(attributes), session_data)
      end

      if form.vehicles.blank?
        form.vehicles = [assign_smod_applicability(VehicleModel.new, session_data)]
      end
      form
    end

    def from_params(params, session_data)
      form = new
      form.vehicles = params.dig("vehicle_model", "vehicles").values.map do |attributes|
        assign_smod_applicability(VehicleModel.from_session(attributes), session_data)
      end
      form
    end

    def session_keys
      [self::SESSION_KEY]
    end

    def assign_smod_applicability(vehicle_model, session_data)
      check = Check.new(session_data)
      vehicle_model.smod_applicable = check.smod_applicable?
      vehicle_model
    end
  end

  def session_attributes
    { self.class::SESSION_KEY => vehicles.map(&:session_attributes) }
  end

private

  def vehicles_valid?
    return if vehicles.all?(&:valid?)

    vehicles.each_with_index do |vehicle, index|
      vehicle.errors.messages.each do |field, messages|
        errors.add(:"vehicles_#{index + 1}_#{field}", messages.first)
      end
    end
  end
end

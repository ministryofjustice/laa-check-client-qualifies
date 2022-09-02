class VehicleForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :vehicle_owned, :boolean
  validates :vehicle_owned, inclusion: {in: [true, false], message: I18n.t("errors.mandatory_yes_no_question")}
end

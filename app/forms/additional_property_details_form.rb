class AdditionalPropertyDetailsForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include SessionPersistableWithPrefix
  include AddAnotherable

  PREFIX = "additional_".freeze

  ITEMS_SESSION_KEY = "additional_property".freeze
  ITEM_MODEL = AdditionalPropertyModel
  ATTRIBUTES = %i[additional_properties].freeze
  alias_attribute :additional_properties, :items
  # ATTRIBUTES = %i[house_value mortgage percentage_owned house_in_dispute].freeze

  delegate :additional_property_owned, :smod_applicable?, to: :check

  def owned_with_mortgage?
    additional_property_owned == "with_mortgage"
  end

  def client_form_variant?
    true
  end
end

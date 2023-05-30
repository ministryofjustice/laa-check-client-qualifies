class ClientAssetsForm < BaseAssetsForm
  ATTRIBUTES = (BASE_ATTRIBUTES + ADD_ANOTHER_ATTRIBUTES + %i[in_dispute property_in_dispute valuables_in_dispute investments_in_dispute savings_in_dispute]).freeze

  # list of assets in SMOD - property, valuables, investments
  attribute :in_dispute, array: true, default: []
  attribute :property_in_dispute, array: true, default: []
  attribute :valuables_in_dispute, array: true, default: []
  attribute :investments_in_dispute, array: true, default: []
  attribute :savings_in_dispute, array: true, default: []

  def self.from_params(params, _session)
    relevant_params = params.fetch(name.underscore, {}).permit(*self::ATTRIBUTES, in_dispute:, property_in_dispute:, valuables_in_dispute:, investments_in_dispute:, savings_in_dispute: [])
    new(relevant_params)
  end
end

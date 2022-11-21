class ClientAssetsForm < BaseAssetsForm
  ATTRIBUTES = (BASE_ATTRIBUTES + %i[in_dispute]).freeze
  # list of assets in SMOD - property, valuables, investments
  attribute :in_dispute, array: true, default: []

  def property_in_dispute?
    in_dispute.include? "property"
  end

  def investments_in_dispute?
    in_dispute.include? "investments"
  end

  def valuables_in_dispute?
    in_dispute.include? "valuables"
  end

  def savings_in_dispute?
    in_dispute.include? "savings"
  end

  def self.from_params(params, _session)
    relevant_params = params.fetch(name.underscore, {}).permit(*self::ATTRIBUTES, in_dispute: [])
    new(relevant_params)
  end
end

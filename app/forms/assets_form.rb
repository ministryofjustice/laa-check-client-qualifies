class AssetsForm < BaseAssetsForm
  ATTRIBUTES = (ASSETS_DECIMAL_ATTRIBUTES + ASSETS_PROPERTY_ATTRIBUTES + %i[property_percentage_owned in_dispute]).freeze
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

  # TODO: Smart hydration of form with in_dispute param
end

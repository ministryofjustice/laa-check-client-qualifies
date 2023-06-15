class ClientAssetsForm < BaseAssetsForm
  ATTRIBUTES = (BASE_ATTRIBUTES + %i[savings]).freeze
  # SAVINGS will be an array of bank accounts
  # need to SMOD individual bank accounts

  # def self.from_params(params, _session)
  #   relevant_params = params.fetch(name.underscore, {}).permit(*self::ATTRIBUTES, :savings)
  #   new(relevant_params)
  # end
end

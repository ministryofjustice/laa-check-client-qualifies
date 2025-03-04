class AdditionalPropertyForm < PropertyForm
  include SessionPersistableWithPrefix
  PREFIX = "additional_".freeze

  def valid_options
    (OWNED_OPTIONS - [:shared_ownership] + NON_OWNED_OPTIONS).map(&:to_s)
  end
end

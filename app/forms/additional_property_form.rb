class AdditionalPropertyForm < PropertyForm
  include SessionPersistableWithPrefix
  PREFIX = "additional_".freeze
end

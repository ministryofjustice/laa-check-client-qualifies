class FeatureFlagOverride < ApplicationRecord
  attribute :key, :string
  attribute :value, :boolean
end

# frozen_string_literal: true

class AssetsForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  BASE_ATTRIBUTES = %i[investments valuables investments_relevant valuables_relevant].freeze

  attribute :investments_relevant, :boolean
  validates :investments_relevant,
            inclusion: { in: [true, false], allow_nil: false },
            if: -> { !FeatureFlags.enabled?(:legacy_assets_no_reveal, check.session_data) }

  attribute :investments, :gbp
  validates :investments,
            numericality: { greater_than_or_equal_to: 0, allow_nil: true },
            presence: { message: :legacy_blank },
            is_a_number: { message: :legacy_not_a_number },
            if: -> { FeatureFlags.enabled?(:legacy_assets_no_reveal, check.session_data) }

  validates :investments,
            numericality: { greater_than: 0, allow_nil: true },
            presence: true,
            is_a_number: true,
            if: -> { !FeatureFlags.enabled?(:legacy_assets_no_reveal, check.session_data) && investments_relevant }

  attribute :valuables_relevant, :boolean
  validates :valuables_relevant,
            inclusion: { in: [true, false], allow_nil: false },
            if: -> { !FeatureFlags.enabled?(:legacy_assets_no_reveal, check.session_data) }

  attribute :valuables, :gbp
  validates :valuables,
            presence: { message: :legacy_blank },
            is_a_number: { message: :legacy_not_a_number },
            if: -> { FeatureFlags.enabled?(:legacy_assets_no_reveal, check.session_data) }

  attribute :valuables, :gbp
  validates :valuables,
            numericality: { greater_than_or_equal_to: 500, allow_nil: true },
            presence: true,
            is_a_number: true,
            if: -> { !FeatureFlags.enabled?(:legacy_assets_no_reveal, check.session_data) && valuables_relevant }

  validate :positive_valuables_must_be_over_500, if: -> { FeatureFlags.enabled?(:legacy_assets_no_reveal, check.session_data) }

  def positive_valuables_must_be_over_500
    return if valuables.to_i <= 0 || valuables >= 500

    errors.add(:valuables, :below_500)
  end
end

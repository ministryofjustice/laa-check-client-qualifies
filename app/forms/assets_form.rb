# frozen_string_literal: true

class AssetsForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  BASE_ATTRIBUTES = %i[investments valuables investments_relevant valuables_relevant].freeze

  attribute :investments_relevant, :boolean
  validates :investments_relevant,
            inclusion: { in: [true, false], allow_nil: false }

  attribute :investments, :gbp
  validates :investments,
            numericality: { greater_than: 0, allow_nil: true },
            presence: { message: :blank },
            is_a_number: { message: :not_a_number },
            if: -> { investments_relevant }

  attribute :valuables_relevant, :boolean
  validates :valuables_relevant,
            inclusion: { in: [true, false], allow_nil: false }

  attribute :valuables, :gbp
  validates :valuables,
            numericality: { greater_than_or_equal_to: 500, allow_nil: true },
            presence: { message: :blank },
            is_a_number: { message: :not_a_number },
            if: -> { valuables_relevant }
end

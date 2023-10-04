class SatisfactionFeedback < ApplicationRecord
  attribute :satisfied, :boolean
  attribute :level_of_help, :string
  attribute :outcome, :string

  validates :satisfied, inclusion: { in: [true, false] }
  validates :outcome, inclusion: { in: OUTCOMES }

  OUTCOMES = %w[eligible eligible_contribution_required inelible].freeze
end

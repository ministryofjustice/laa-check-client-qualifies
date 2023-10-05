class FreetextFeedback < ApplicationRecord
  attribute :text, :text
  attribute :page, :string
  attribute :level_of_help, :string

  validates :text, presence: true
  validates :page, presence: true
end

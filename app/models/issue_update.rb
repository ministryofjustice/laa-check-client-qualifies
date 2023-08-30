class IssueUpdate < ApplicationRecord
  belongs_to :issue
  attribute :content, :string
  attribute :utc_timestamp, :datetime, default: -> { Time.zone.now }
  validates :content, :utc_timestamp, presence: true

  def time_for_display
    utc_timestamp.in_time_zone("London")
  end
end

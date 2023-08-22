class IssueUpdate < ApplicationRecord
  belongs_to :issue
  attribute :content, :string
  attribute :published_at, :datetime, default: -> { Time.zone.now }

  def time_for_display
    published_at.in_time_zone("London")
  end
end

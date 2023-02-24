class AnalyticsEvent < ApplicationRecord
  attribute :page, :string
  attribute :event_type, :string
  attribute :assessment_code, :string
  attribute :browser_id, :string
  attribute :created_at, :datetime
end

class IssueUpdate < ApplicationRecord
  belongs_to :issue
  attribute :content, :string
  attribute :published_at, :datetime
end

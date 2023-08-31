class Issue < ApplicationRecord
  enum :status, { draft: "draft", active: "active", resolved: "resolved" }
  has_many :issue_updates
  attribute :title, :string
  attribute :banner_content, :string

  # This is a non-database attribute
  attribute :initial_update_content, :string

  validates :title, :status, :banner_content, presence: true
  validate :initial_update_content_not_blank

  def self.for_banner_display
    joins(:issue_updates).where("status = ? OR (status = ? AND issue_updates.utc_timestamp > ?)", statuses[:active], statuses[:resolved], 24.hours.ago)
                         .uniq
  end

  def self.for_updates_page
    issues = Issue.joins(:issue_updates).where(status: [statuses[:active], statuses[:resolved]]).uniq
    change_logs = ChangeLogs.occurred
    sorted = (issues + change_logs).sort_by do |issue_or_change_log|
      if issue_or_change_log.is_a?(Issue)
        issue_or_change_log.issue_updates.maximum(:utc_timestamp).in_time_zone("London")
      else
        Date.parse(issue_or_change_log[:change_on])
      end
    end

    sorted.reverse
  end

  def title_for_sentences
    "#{title[0].downcase}#{title[1..]}"
  end

  def initial_update_content_not_blank
    # If it's assigned _at all_ then it needs a real value. Empty strings are not permitted
    return if initial_update_content.nil? || initial_update_content.present?

    errors.add(:initial_update_content, :blank)
  end
end

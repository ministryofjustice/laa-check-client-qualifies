class Issue < ApplicationRecord
  enum :status, { draft: "draft", active: "active", resolved: "resolved" }
  has_many :issue_updates
  attribute :title, :string
  attribute :banner_content, :string

  def self.for_banner_display
    joins(:issue_updates).where("status = ? OR (status = ? AND issue_updates.published_at > ?)", statuses[:active], statuses[:resolved], 24.hours.ago)
                         .uniq
  end

  def self.for_updates_page
    issues = Issue.joins(:issue_updates).where(status: [statuses[:active], statuses[:resolved]]).uniq
    change_logs = ChangeLogs.occurred
    sorted = (issues + change_logs).sort_by do |issue_or_change_log|
      if issue_or_change_log.is_a?(Issue)
        issue_or_change_log.issue_updates.maximum(:published_at)
      else
        Date.parse(issue_or_change_log[:change_on])
      end
    end

    sorted.reverse
  end
end

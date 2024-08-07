class ChangeLog < ApplicationRecord
  enum :tag, { mtr: "mtr", policy_update: "policy_update", feature: "feature" }

  before_save :apply_govuk_classes

  has_rich_text :content

  validates :released_on, :title, :content, presence: true

  def self.anything_to_display?
    change_logs_and_issues_for_updates_page.any?
  end

  def self.latest_update_date
    issue_or_change_log = change_logs_and_issues_for_updates_page.first
    time = if issue_or_change_log.is_a?(Issue)
             issue_or_change_log.latest_update_time
           else
             issue_or_change_log.released_on
           end
    time.strftime("%-d %B %Y")
  end

  def self.change_logs_for_updates_page
    where(published: true).order(released_on: :desc)
  end

  def self.change_logs_and_issues_for_updates_page
    sorted = (Issue.issues_for_updates_page + change_logs_for_updates_page).sort_by do |issue_or_change_log|
      if issue_or_change_log.is_a?(Issue)
        issue_or_change_log.latest_update_time
      else
        issue_or_change_log.released_on
      end
    end

    sorted.reverse
  end

  # RailsAdmin uses a pre 2.0 version of Trix that doesn't allow adding custom CSS classes to elements
  # as you type, so we have to apply them before save instead
  def apply_govuk_classes
    self.content = GovukStyleService.call(content)
  end
end

#------------------------------------------------------------------------------
# ChangeLog
#
# Name        SQL Type             Null    Primary Default
# ----------- -------------------- ------- ------- ----------
# id          bigint               false   true
# title       character varying    false   false
# tag         character varying    true    false
# released_on date                 false   false
# published   boolean              false   false   false
# created_at  timestamp(6) without time zone false   false
# updated_at  timestamp(6) without time zone false   false
#
#------------------------------------------------------------------------------

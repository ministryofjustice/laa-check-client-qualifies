class ChangeLog < ApplicationRecord
  attribute :released_on, :date
  attribute :title, :string
  attribute :published, :boolean, default: false
  enum :tag, { mtr: "mtr", policy_update: "policy_update" }

  before_save :apply_govuk_classes

  has_rich_text :content

  validates :released_on, :title, :content, presence: true

  def self.anything_to_display?
    for_updates_page.any?
  end

  def self.latest_update_time
    issue_or_change_log = for_updates_page.first
    time = if issue_or_change_log.is_a?(Issue)
      issue_or_change_log.latest_update_time
    else
      issue_or_change_log.released_on
    end
    time.strftime("%-d %B %Y")
  end

  def self.for_display
    where(published: true).order(released_on: :desc)
  end

  def self.for_updates_page
    sorted = (Issue.for_updates_page + for_display).sort_by do |issue_or_change_log|
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

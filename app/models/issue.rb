class Issue < ApplicationRecord
  enum :status, { draft: "draft", active: "active", resolved: "resolved" }
  has_many :issue_updates

  # This is a non-database attribute
  attribute :initial_update_content, :string

  validates :title, :status, :banner_content, presence: true
  validate :initial_update_content_not_blank

  def latest_update_time
    issue_updates.order(utc_timestamp: :desc).first.time_for_display
  end

  def self.for_banner_display
    joins(:issue_updates).where("status = ? OR (status = ? AND issue_updates.utc_timestamp > ?)", statuses[:active], statuses[:resolved], 24.hours.ago)
                         .uniq
  end

  def self.issues_for_updates_page
    Issue.joins(:issue_updates).where(status: [statuses[:active], statuses[:resolved]]).uniq
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

#------------------------------------------------------------------------------
# Issue
#
# Name           SQL Type             Null    Primary Default
# -------------- -------------------- ------- ------- ----------
# id             bigint               false   true              
# title          character varying    false   false             
# banner_content text                 false   false             
# status         character varying    false   false             
# created_at     timestamp(6) without time zone false   false             
# updated_at     timestamp(6) without time zone false   false             
#
#------------------------------------------------------------------------------

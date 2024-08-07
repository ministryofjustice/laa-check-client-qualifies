class IssueUpdate < ApplicationRecord
  belongs_to :issue
  # Default the timestamp to the current time if not set
  before_validation do |issue_update|
    issue_update.utc_timestamp ||= Time.zone.now
  end
  validates :content, :utc_timestamp, presence: true

  def time_for_display
    utc_timestamp.in_time_zone("London")
  end
end

#------------------------------------------------------------------------------
# IssueUpdate
#
# Name          SQL Type             Null    Primary Default
# ------------- -------------------- ------- ------- ----------
# id            bigint               false   true
# issue_id      bigint               true    false
# content       text                 false   false
# utc_timestamp timestamp(6) without time zone false   false
# created_at    timestamp(6) without time zone false   false
# updated_at    timestamp(6) without time zone false   false
#
#------------------------------------------------------------------------------

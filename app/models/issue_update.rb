class IssueUpdate < ApplicationRecord
  belongs_to :issue
  # This attribute has to be duplicated here so that the default works
  attribute :utc_timestamp, :datetime, default: -> { Time.zone.now }
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

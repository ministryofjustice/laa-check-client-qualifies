class AnalyticsEvent < ApplicationRecord
  validates :event_type, :page, presence: true
end

#------------------------------------------------------------------------------
# AnalyticsEvent
#
# Name            SQL Type             Null    Primary Default
# --------------- -------------------- ------- ------- ----------
# id              bigint               false   true
# event_type      character varying    false   false
# page            character varying    false   false
# assessment_code character varying    true    false
# browser_id      character varying    true    false
# created_at      timestamp(6) without time zone false   false
# updated_at      timestamp(6) without time zone false   false
#
#------------------------------------------------------------------------------

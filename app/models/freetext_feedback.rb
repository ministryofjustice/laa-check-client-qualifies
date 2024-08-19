class FreetextFeedback < ApplicationRecord
  validates :text, presence: true
  validates :page, presence: true
end

#------------------------------------------------------------------------------
# FreetextFeedback
#
# Name          SQL Type             Null    Primary Default
# ------------- -------------------- ------- ------- ----------
# id            bigint               false   true
# text          text                 false   false
# page          character varying    false   false
# level_of_help character varying    true    false
# created_at    timestamp(6) without time zone false   false
# updated_at    timestamp(6) without time zone false   false
#
#------------------------------------------------------------------------------

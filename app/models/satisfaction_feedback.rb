class SatisfactionFeedback < ApplicationRecord
  validates :satisfied, presence: true, inclusion: { in: %w[yes no] }
  validates :level_of_help, presence: true
  validates :outcome, presence: true
end

#------------------------------------------------------------------------------
# SatisfactionFeedback
#
# Name          SQL Type             Null    Primary Default
# ------------- -------------------- ------- ------- ----------
# id            bigint               false   true              
# satisfied     character varying    false   false             
# level_of_help character varying    false   false             
# outcome       character varying    false   false             
# created_at    timestamp(6) without time zone false   false             
# updated_at    timestamp(6) without time zone false   false             
# comment       text                 true    false             
#
#------------------------------------------------------------------------------

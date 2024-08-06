class FeatureFlagOverride < ApplicationRecord
end

#------------------------------------------------------------------------------
# FeatureFlagOverride
#
# Name       SQL Type             Null    Primary Default
# ---------- -------------------- ------- ------- ----------
# id         bigint               false   true              
# key        character varying    true    false             
# value      boolean              true    false             
# created_at timestamp(6) without time zone false   false             
# updated_at timestamp(6) without time zone false   false             
#
#------------------------------------------------------------------------------

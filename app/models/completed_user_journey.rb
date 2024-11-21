class CompletedUserJourney < ApplicationRecord
end

#----------------------------------------------------------------------------------
# CompletedUserJourney
#
# Name                     SQL Type             Null    Primary Default
# --------------------     -------------------- ------- ------- ----------
# id                       bigint               false   true
# assessment_id            character varying    false   false
# certificated             boolean              false   false
# partner                  boolean              false   false
# person_over_60           boolean              false   false
# passported               boolean              false   false
# main_dwelling_owned      boolean              true    false
# vehicle_owned            boolean              true    false
# smod_assets              boolean              true    false
# outcome                  character varying    false   false
# capital_contribution     boolean              true    false
# income_contribution      boolean              false   false
# completed                date                 true    false
# form_downloaded          boolean              true    false   false
# matter_type              character varying    true    false
# asylum_support           boolean              true    false
# client_age               character varying    true    false
# session                  jsonb                true    false
# office_code              character varying    true    false
# early_result_type        character varying    true    false
# early_eligibility_result boolean              false   false
#
#----------------------------------------------------------------------------------

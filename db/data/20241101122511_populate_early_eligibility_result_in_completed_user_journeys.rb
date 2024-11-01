# frozen_string_literal: true

class PopulateEarlyEligibilityResultInCompletedUserJourneys < ActiveRecord::Migration[7.2]
  def up
    CompletedUserJourney.find_each do |check|
      session_data_hash = check.session || {}
      early_eligibility_result = session_data_hash["early_eligibility_selection"] == "gross"
      check.update_columns(early_eligibility_result:)
    end
  end
end

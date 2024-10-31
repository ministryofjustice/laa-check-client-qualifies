class AddEarlyEligibilityResultToCompletedUserJourneys < ActiveRecord::Migration[7.2]
  def change
    add_column :completed_user_journeys, :early_eligibility_result, :boolean
  end
end

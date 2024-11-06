class ChangeAssessmentIdInCompletedUserJourneys < ActiveRecord::Migration[7.2]
  def change
    remove_index :completed_user_journeys, column: :assessment_id, unique: true
    add_index :completed_user_journeys, :assessment_id, unique: false
  end
end

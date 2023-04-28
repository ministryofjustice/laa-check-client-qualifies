class AddCompletedToCompletedUserJourneys < ActiveRecord::Migration[7.0]
  def change
    change_table :completed_user_journeys, bulk: true do |t|
      t.date :completed
      t.remove :created_at, :updated_at, type: :datetime
    end
  end
end

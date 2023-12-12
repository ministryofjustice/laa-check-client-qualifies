class AddSessionToCompletedUserJourneys < ActiveRecord::Migration[7.1]
  def change
    add_column :completed_user_journeys, :session, :jsonb
  end
end

class AddClientAgeToCompletedUserJourneys < ActiveRecord::Migration[7.1]
  def change
    add_column :completed_user_journeys, :client_age, :string
  end
end

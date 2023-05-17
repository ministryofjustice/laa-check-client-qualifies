class AddMatterTypeToCompletedUserJourneys < ActiveRecord::Migration[7.0]
  def change
    add_column :completed_user_journeys, :matter_type, :string
  end
end

class AddAsylumSupportToCompletedUserJourneys < ActiveRecord::Migration[7.0]
  def change
    add_column :completed_user_journeys, :asylum_support, :boolean
  end
end

class AmmenedCompletedUserJourneyForEarlyResultType < ActiveRecord::Migration[7.1]
  def change
    change_table :completed_user_journeys, bulk: true do |t|
      t.column :early_result_type, :string, null: true
      t.change_null :main_dwelling_owned, true
      t.change_null :vehicle_owned, true
      t.change_null :smod_assets, true
      t.change_null :capital_contribution, true
    end
  end
end

class CreateCompletedUserJourneys < ActiveRecord::Migration[7.0]
  def change
    create_table :completed_user_journeys do |t|
      t.string :assessment_id, null: false
      t.boolean :certificated, null: false
      t.boolean :partner, null: false
      t.boolean :person_over_60, null: false
      t.boolean :passported, null: false
      t.boolean :main_dwelling_owned, null: false
      t.boolean :vehicle_owned, null: false
      t.boolean :smod_assets, null: false
      t.string :outcome, null: false
      t.boolean :capital_contribution, null: false
      t.boolean :income_contribution, null: false

      t.timestamps
    end

    add_index :completed_user_journeys, :assessment_id, unique: true
  end
end

class CreateFeatureFlagOverrides < ActiveRecord::Migration[7.0]
  def change
    create_table :feature_flag_overrides do |t|
      t.string :key
      t.boolean :value

      t.timestamps
    end
  end
end

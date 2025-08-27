class RemoveProviders < ActiveRecord::Migration[7.2]
  def change
    drop_table :providers, if_exists: true do |t|
      t.string :email, null: false
      t.string :first_office_code
      t.timestamps
    end
  end
end

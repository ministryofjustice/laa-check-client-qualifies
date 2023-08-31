class CreateChangeLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :change_logs do |t|
      t.string :title, null: false
      t.string :tag
      t.date :released_on, null: false
      t.boolean :published, null: false, default: false
      t.timestamps
    end
  end
end

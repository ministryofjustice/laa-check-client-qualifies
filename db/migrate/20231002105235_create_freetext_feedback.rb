class CreateFreetextFeedback < ActiveRecord::Migration[7.0]
  def change
    create_table :freetext_feedbacks do |t|
      t.text :text, null: false
      t.string :page, null: false
      t.string :level_of_help

      t.timestamps
    end
  end
end

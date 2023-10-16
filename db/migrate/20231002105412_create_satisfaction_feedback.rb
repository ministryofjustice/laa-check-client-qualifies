class CreateSatisfactionFeedback < ActiveRecord::Migration[7.0]
  def change
    create_table :satisfaction_feedbacks do |t|
      t.string :satisfied, null: false
      t.string :level_of_help, null: false
      t.string :outcome, null: false

      t.timestamps
    end
  end
end

class CreateAnalyticsEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :analytics_events do |t|
      t.string :event_type, null: false
      t.string :page, null: false
      t.string :assessment_code
      t.string :browser_id
      t.timestamps
      t.index :created_at
      t.index :assessment_code
    end
  end
end

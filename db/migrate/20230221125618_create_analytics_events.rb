class CreateAnalyticsEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :analytics_events do |t|
      t.string :event_type
      t.string :page
      t.string :assessment_code
      t.string :browser_id

      t.timestamps
    end
  end
end

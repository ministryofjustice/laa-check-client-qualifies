class RemoveBlazer < ActiveRecord::Migration[7.1]
  def change
    drop_table :blazer_queries do |t|
      t.references :creator
      t.string :name
      t.text :description
      t.text :statement
      t.string :data_source
      t.string :status
      t.timestamps null: false
    end

    drop_table :blazer_audits do |t|
      t.references :user
      t.references :query
      t.text :statement
      t.string :data_source
      t.datetime :created_at
    end

    drop_table :blazer_dashboards do |t|
      t.references :creator
      t.string :name
      t.timestamps null: false
    end

    drop_table :blazer_dashboard_queries do |t|
      t.references :dashboard
      t.references :query
      t.integer :position
      t.timestamps null: false
    end

    drop_table :blazer_checks do |t|
      t.references :creator
      t.references :query
      t.string :state
      t.string :schedule
      t.text :emails
      t.text :slack_channels
      t.string :check_type
      t.text :message
      t.datetime :last_run_at
      t.timestamps null: false
    end

    # remove read-only blazer role created in 20230426104843_add_blazer_permissions.rb
    # https://stackoverflow.com/questions/65585493/how-to-execute-drop-owned-by-only-if-the-user-exists
    drop_owned = ApplicationRecord.connection.execute("SELECT 'DROP OWNED BY blazer' AS a FROM pg_roles WHERE rolname = 'blazer';")

    # check number of SQL rows affected (which is same as rows returned)
    if drop_owned.cmd_tuples.positive?
      # The 'a' here is the same as the 'AS a' in the above select statement
      ApplicationRecord.connection.execute(drop_owned[0]["a"])
    end
    ApplicationRecord.connection.execute("DROP ROLE if exists blazer;")
  end
end

class AddBlazerPermissions < ActiveRecord::Migration[7.0]
  def up
    # Note this will never to true in non-UAT environments
    # without it UAT migrations can't run properly once blazer password has been removed
    # as they run all migrations on startup
    password = ENV.fetch("BLAZER_DATABASE_PASSWORD", "password")

    ApplicationRecord.connection.execute(
      "BEGIN;
      CREATE ROLE blazer LOGIN PASSWORD '#{password}';
      GRANT CONNECT ON DATABASE #{ENV['POSTGRES_DATABASE']} TO blazer;
      GRANT USAGE ON SCHEMA public TO blazer;
      GRANT SELECT ON ALL TABLES IN SCHEMA public TO blazer;
      ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO blazer;
      COMMIT;",
    )
  end
end

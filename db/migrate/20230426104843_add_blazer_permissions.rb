class AddBlazerPermissions < ActiveRecord::Migration[7.0]
  def up
    return if ENV["BLAZER_DATABASE_PASSWORD"].blank?

    ApplicationRecord.connection.execute(
      "BEGIN;
      CREATE ROLE blazer LOGIN PASSWORD '#{ENV['BLAZER_DATABASE_PASSWORD']}';
      GRANT CONNECT ON DATABASE #{ENV['POSTGRES_DATABASE']} TO blazer;
      GRANT USAGE ON SCHEMA public TO blazer;
      GRANT SELECT ON ALL TABLES IN SCHEMA public TO blazer;
      ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO blazer;
      COMMIT;",
    )
  end
end

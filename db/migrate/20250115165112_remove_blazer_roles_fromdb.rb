class RemoveBlazerRolesFromdb < ActiveRecord::Migration[7.2]
  def change
    # Check if the 'blazer' role exists
    role_exists = ApplicationRecord.connection.execute("SELECT 1 FROM pg_roles WHERE rolname = 'blazer';").to_a.any?

    if role_exists
      Rails.logger.debug "Role 'blazer' exists. Checking owned objects and dependencies..."

      # List all objects owned by blazer
      owned_objects = ApplicationRecord.connection.execute(<<-SQL
        SELECT c.relname, n.nspname 
        FROM pg_class c 
        JOIN pg_namespace n ON n.oid = c.relnamespace 
        WHERE c.relowner = (SELECT oid FROM pg_roles WHERE rolname = 'blazer');
      SQL
      ).to_a

      begin
        # Drop remaining dependencies before dropping the role
        ApplicationRecord.connection.execute("DROP OWNED BY blazer CASCADE;")
        Rails.logger.debug "Dropped remaining dependencies owned by 'blazer'."
      rescue ActiveRecord::StatementInvalid => e
        Rails.logger.error "Failed to drop dependencies: #{e.message}"
        raise
      end

      # Drop the role
      ApplicationRecord.connection.execute("DROP ROLE IF EXISTS blazer;")
      Rails.logger.debug "Role 'blazer' has been dropped."
    else
      Rails.logger.debug "Role 'blazer' does not exist. Skipping migration."
    end
  end
end

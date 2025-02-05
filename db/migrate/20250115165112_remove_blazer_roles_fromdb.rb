class RemoveBlazerRolesFromdb < ActiveRecord::Migration[7.2]
  def change
    # Check if the 'blazer' role exists
    role_exists = ApplicationRecord.connection.execute("SELECT 1 FROM pg_roles WHERE rolname = 'blazer';").any?

    if role_exists
      Rails.logger.debug "Role 'blazer' exists. Reassigning owned objects and dropping role..."

      # Reassign owned objects to postgres before dropping
      ApplicationRecord.connection.execute("REASSIGN OWNED BY blazer TO postgres;")
      Rails.logger.debug "Reassigned owned objects from 'blazer' to 'postgres'."

      # Drop the role
      ApplicationRecord.connection.execute("DROP ROLE IF EXISTS blazer;")
      Rails.logger.debug "Role 'blazer' has been dropped."
    else
      Rails.logger.debug "Role 'blazer' does not exist. Skipping migration."
    end
  end
end

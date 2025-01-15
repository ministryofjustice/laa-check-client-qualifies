class RemoveBlazerRolesFromdb < ActiveRecord::Migration[7.2]
  def change
    # Check if the 'blazer' role exists and prepare the 'DROP OWNED BY' command if it does
    drop_owned = ApplicationRecord.connection.execute("SELECT 'DROP OWNED BY blazer' AS a FROM pg_roles WHERE rolname = 'blazer';")

    if drop_owned.cmd_tuples.positive?
      Rails.logger.debug "Role 'blazer' exists. Dropping owned objects by 'blazer'..."
      # Execute the 'DROP OWNED BY' statement
      ApplicationRecord.connection.execute(drop_owned[0]["a"])
      Rails.logger.debug "'DROP OWNED BY blazer' executed successfully."
    else
      Rails.logger.debug "Role 'blazer' does not exist. No need to drop owned objects."
    end

    # Drop the role itself if it exists
    ApplicationRecord.connection.execute("DROP ROLE IF EXISTS blazer;")
    Rails.logger.debug "Role 'blazer' has been dropped (if it existed)."
  end
end

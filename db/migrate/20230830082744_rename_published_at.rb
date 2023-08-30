class RenamePublishedAt < ActiveRecord::Migration[7.0]
  def change
    rename_column :issue_updates, :published_at, :utc_timestamp
  end
end

class AddFormDownloadedToCompletedUserJourney < ActiveRecord::Migration[7.0]
  def change
    add_column :completed_user_journeys, :form_downloaded, :boolean, default: false
  end
end

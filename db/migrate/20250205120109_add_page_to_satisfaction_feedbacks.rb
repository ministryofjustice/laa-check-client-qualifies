class AddPageToSatisfactionFeedbacks < ActiveRecord::Migration[7.2]
  def change
    add_column :satisfaction_feedbacks, :page, :string
  end
end

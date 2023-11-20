class AddCommentToSatisfactionFeedback < ActiveRecord::Migration[7.1]
  def change
    add_column :satisfaction_feedbacks, :comment, :text
  end
end

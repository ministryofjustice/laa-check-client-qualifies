class CreateIssues < ActiveRecord::Migration[7.0]
  def change
    create_table :issues do |t|
      t.string :title
      t.text :banner_content
      t.string :status

      t.timestamps
    end

    create_table :issue_updates do |t|
      t.references :issue, index: true
      t.text :content
      t.datetime :published_at

      t.timestamps
    end
  end
end

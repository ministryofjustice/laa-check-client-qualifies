class MakeContentNonOptional < ActiveRecord::Migration[7.0]
  def up
    change_table :issues, bulk: true do |t|
      t.change "banner_content", :text, null: false
      t.change "title", :string, null: false
      t.change "status", :string, null: false
    end

    change_table :issue_updates, bulk: true do |t|
      t.change "content", :text, null: false
      t.change "published_at", :datetime, null: false
    end
  end

  def down
    change_table :issues, bulk: true do |t|
      t.change "banner_content", :text, null: true
      t.change "title", :string, null: true
      t.change "status", :string, null: true
    end

    change_table :issue_updates, bulk: true do |t|
      t.change "content", :text, null: true
      t.change "published_at", :datetime, null: true
    end
  end
end

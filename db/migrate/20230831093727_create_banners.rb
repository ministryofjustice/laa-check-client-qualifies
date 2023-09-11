class CreateBanners < ActiveRecord::Migration[7.0]
  def change
    create_table :banners do |t|
      t.string :title, null: false
      t.timestamp :display_from_utc, null: false
      t.timestamp :display_until_utc, null: false
      t.boolean :published, null: false, default: false
      t.timestamps
    end
  end
end

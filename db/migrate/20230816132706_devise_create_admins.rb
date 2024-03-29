# frozen_string_literal: true

class DeviseCreateAdmins < ActiveRecord::Migration[7.0]
  def up
    create_table :admins do |t|
      t.string :email

      t.timestamps null: false
    end

    return if ENV["SEED_ADMINS"].blank?

    ENV["SEED_ADMINS"].split(",").each { Admin.create!(email: _1) }
  end

  def down
    drop_table :admins
  end
end

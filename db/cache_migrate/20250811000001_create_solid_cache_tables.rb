# frozen_string_literal: true

class CreateSolidCacheTables < ActiveRecord::Migration[8.0]
  def change
    create_table :solid_cache_entries, id: :binary, limit: 20, force: true do |t|
      t.binary :key, limit: 1024, null: false
      t.text :value, limit: 512.megabytes, null: false
      t.datetime :created_at, null: false
      t.integer :key_hash, null: false, limit: 8
      t.integer :byte_size, null: false, limit: 4

      t.index :key_hash
      t.index [:key_hash, :byte_size]
      t.index :created_at
    end
  end
end

class AddOfficeCodeToProvider < ActiveRecord::Migration[7.1]
  def change
    change_table :providers do |t|
      t.string :first_office_code
    end
    change_table :completed_user_journeys do |t|
      t.string :office_code
    end
  end
end

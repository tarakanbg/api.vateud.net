class CreateWelcomeEmails < ActiveRecord::Migration
  def change
    create_table :welcome_emails do |t|
      t.integer :member_id

      t.timestamps
    end
  end
end

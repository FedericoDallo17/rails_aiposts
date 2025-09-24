class CreateNotifications < ActiveRecord::Migration[8.0]
  def change
    create_table :notifications do |t|
      t.string :title
      t.text :content
      t.string :notification_type
      t.boolean :read, default: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    
    add_index :notifications, [:user_id, :read]
    add_index :notifications, :notification_type
  end
end

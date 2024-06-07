class AddConstraintsInApplications < ActiveRecord::Migration[7.1]
  def change
    change_column_null :applications, :name, false
    change_column_null :chats, :name, false
    change_column_default :applications, :chats_count, 0
    change_column_default :chats, :messages_count, 0
    add_index :chats, :chat_number, unique: true
    rename_column :messages, :message, :content
    change_column_null :messages, :content, false
    change_column_null :messages, :sender, false
    add_index :messages, :message_number, unique: true
  end
end

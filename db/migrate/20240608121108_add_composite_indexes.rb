class AddCompositeIndexes < ActiveRecord::Migration[7.1]
  def change
    add_index :chats, [:application_id, :chat_number]
    add_index :messages, [:chat_id, :message_number]
  end
end

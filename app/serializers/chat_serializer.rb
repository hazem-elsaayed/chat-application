class ChatSerializer < ActiveModel::Serializer
  attributes :chat_number, :messages_count, :name
end

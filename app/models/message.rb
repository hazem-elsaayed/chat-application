class Message < ApplicationRecord
  validates :sender, :content, :message_number, presence: true
  validates :message_number, uniqueness: true
  belongs_to :chat, class_name: 'Chat', foreign_key: 'chat_id'
end

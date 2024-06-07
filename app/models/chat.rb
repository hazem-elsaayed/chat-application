class Chat < ApplicationRecord
  belongs_to :application, class_name: "Application", foreign_key: "application_id"
  has_many :message, class_name: "Message", foreign_key: "chat_id"
  validates :name, :chat_number, presence: true
  validates :chat_number, uniqueness: true
end

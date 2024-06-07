class MessageSerializer < ActiveModel::Serializer
  attributes :sender, :content, :message_number
end

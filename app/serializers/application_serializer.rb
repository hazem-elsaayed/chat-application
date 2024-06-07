class ApplicationSerializer < ActiveModel::Serializer
  attributes :name, :chats_count, :token
end

require 'rufus-scheduler'
s = Rufus::Scheduler.singleton

s.every '45m' do
    chats_count = Chat.group(:application_id).count
    messages_count = Message.group(:chat_id).count

    chats_count.each do |application_id, count|
        Application.where(id: application_id).update(chats_count: count)
    end

    messages_count.each do |chat_id, count|
        Chat.where(id: chat_id).update(messages_count: count)
    end

    Rails.logger.info "hello, it's #{Time.now}"
    Rails.logger.flush
end
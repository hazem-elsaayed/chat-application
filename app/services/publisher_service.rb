class PublisherService

  def initialize
    return if ENV['DISABLE_RABBITMQ'] || ENV['RAILS_ENV'] == 'test'
    @mq_service = BaseQueueService.instance
    puts 'Publisher Channel Created'
  end

  def publish_message(queue_name, msg)
    return if ENV['DISABLE_RABBITMQ'] || ENV['RAILS_ENV'] == 'test'
    channel = @mq_service.channel
    queue = channel.queue(queue_name, durable: true)
    channel.default_exchange.publish(msg, routing_key: queue.name, persistent: true)
    puts " Message sent #{msg}"
  end
end

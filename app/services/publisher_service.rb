class PublisherService

  def initialize
    @mq_service = BaseQueueService.instance
    puts 'Publisher Channel Created'
  end

  def publish_message(queue_name, msg)
    channel = @mq_service.channel
    queue = channel.queue(queue_name, durable: true)
    channel.default_exchange.publish(msg, routing_key: queue.name, persistent: true)
    puts " Message sent #{msg}"
  end
end

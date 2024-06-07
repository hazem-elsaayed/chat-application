class ConsumerService

  def initialize
    @mq_service = BaseQueueService.instance
    @channel = @mq_service.channel
    @channel.prefetch(1)
    puts 'Consumer Channel Created'
  end

  def consume_message(queue_name, model)
    queue = @channel.queue(queue_name, durable: true)
    puts 'Start Consuming Message'
    begin
      queue.subscribe(manual_ack: true) do |delivery_info, _properties, payload|
        puts " [x] Received '#{payload}'"
        msg = JSON.parse(payload)
        model.create!(msg)
        channel.ack(delivery_info.delivery_tag)
      end
    rescue StandardError => e
      puts e
    end
  end
end

class ConsumerService

  def initialize
    return if ENV['DISABLE_RABBITMQ']
    @mq_service = BaseQueueService.instance
    @channel = @mq_service.channel
    @channel.prefetch(1)
    puts 'Consumer Channel Created'
  end

  def consume_message(queue_name, model)
    return if ENV['DISABLE_RABBITMQ']
    queue = @channel.queue(queue_name, durable: true)
    puts "Start Consuming Message for #{model.name}"
    begin
      queue.subscribe(manual_ack: true) do |delivery_info, _properties, payload|
        puts " [x] Received '#{payload}'"
        msg = JSON.parse(payload)
        model.create!(msg)
        @channel.ack(delivery_info.delivery_tag)
        puts " [x] Acknowledged '#{payload}'"
      end
    rescue StandardError => e
      puts e
    end
  end
end

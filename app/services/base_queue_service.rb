require 'singleton'

class BaseQueueService
  include Singleton
  attr_accessor :connection, :channel

  def initialize
    return if ENV['DISABLE_RABBITMQ']
    @connection = Bunny.new(automatically_recover: true, host: ENV.fetch('RABBITMQ_HOST'))
    @connection.start
    @channel = @connection.create_channel
    channel
  end

  def close
    @connection.close unless ENV['DISABLE_RABBITMQ']
  end
end

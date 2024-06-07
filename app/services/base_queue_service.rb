require 'singleton'

class BaseQueueService
  include Singleton
  attr_accessor :connection, :channel

  def initialize
    @connection = Bunny.new(automatically_recover: true, host: 'localhost')
    @connection.start
    @channel = @connection.create_channel
    channel
  end

  def close
    @connection.close
  end

end

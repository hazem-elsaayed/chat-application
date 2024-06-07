class MessagesController < ApplicationController
  before_action :set_chat

  def create
    message_number = get_message_number
    message = @chat.message.new(message_params.merge(message_number: message_number))
    raise message.errors.full_messages.join(', ') if message.invalid?
    PUBLISHER.publish_message('message', message.to_json)
    render json: { success: true, message_number: message_number }
  rescue StandardError => e
    render json: { success: false, message: e }, status: :bad_request
  end

  def index
    render json: @chat.message
  end

  def show
    message = @chat.message.find_by!(message_number: params[:message_number])
    render json: message
  rescue StandardError => e
    render json: { success: false, message: e }, status: :bad_request
  end

  def update
    Message.transaction do
      message = @chat.message.lock.find_by!(message_number: params[:message_number])
      message.update!(message_params)
    end
    render json: { success: true, message: 'successfully updated' }
  rescue StandardError => e
    render json: { success: false, message: e }, status: :bad_request
  end

  def search
    return render json: { success: false, message: 'empty query' }, status: :bad_request if params[:query].blank?

    query = Message.search(params[:query].to_s, @chat.id)
    render json: query.records
  end

  private

  def set_chat
    @chat = Application.find_by!(token: params[:application_token]).chat.find_by!(chat_number: params[:chat_number])
  rescue StandardError => e
    render json: { success: false, message: e }, status: :bad_request
  end

  def message_params
    params.permit(:sender, :content)
  end

  def get_message_number
    unless REDIS.exists?("message_number_#{params[:application_token]}_#{params[:chat_number]}")
      REDIS.set("message_number_#{params[:application_token]}_#{params[:chat_number]}", 0)
    end
    REDIS.incr("message_number_#{params[:application_token]}_#{params[:chat_number]}")
  end
end

class ChatsController < ApplicationController
  before_action :set_application

  def create
    chat_number = get_chat_number
    chat = @application.chat.new(name: params[:name], chat_number: chat_number)
    raise chat.errors.full_messages.join(', ') if chat.invalid?
    PUBLISHER.publish_message('chat', chat.to_json)
    render json: { success: true, chat_number: chat_number }
  rescue StandardError => e
    render json: { success: false, message: e }, status: :bad_request
  end

  def index
    chats = @application.chat
    render json: chats
  rescue StandardError => e
    render json: { success: false, message: e }, status: :bad_request
  end

  def show
    chat = @application.chat.find_by!(chat_number: params[:chat_number])
    render json: chat
  rescue StandardError => e
    render json: { success: false, message: e }, status: :bad_request
  end

  def update
    Chat.transaction do
      chat = @application.chat.lock.find_by!(chat_number: params[:chat_number])
      chat.update!(name: params[:name])
    end
    render json: { success: true, message: 'successfully updated' }
  rescue StandardError => e
    render json: { success: false, message: e }, status: :bad_request
  end

  private

  def set_application
    @application = Application.find_by!(token: params[:application_token])
  rescue StandardError => e
    render json: { success: false, message: e }, status: :bad_request
  end

  def get_chat_number
    unless REDIS.exists?("chat_number_#{params[:application_token]}")
      REDIS.set("chat_number_#{params[:application_token]}", 0)
    end
    REDIS.incr("chat_number_#{params[:application_token]}")
  end
end

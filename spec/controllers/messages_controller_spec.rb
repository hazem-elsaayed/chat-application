require 'rails_helper'

RSpec.describe MessagesController, type: :request do
  fixtures :chats, :applications, :messages
  before do
  allow(REDIS).to receive(:exists).and_return(true)
  allow(REDIS).to receive(:set).and_return(true)
  allow(REDIS).to receive(:incr).and_return(4)
  allow(PUBLISHER).to receive(:publish_message).and_return(true)
  end

  describe 'POST #create' do
    let(:chat) { chats(:one) }
    let(:application) { applications(:one) }
    let(:valid_params) { { sender: 'John', content: 'Hello' } }
    let(:invalid_params) { { sender: '', content: '' } }
    
    context 'with valid params' do
      it 'creates a new message' do
        post "/applications/#{application.token}/chats/#{chat.chat_number}/messages", params:  valid_params, as: :json
        expect(JSON.parse(response.body)["message_number"]).to eq(4)
      end

      it 'returns a success response' do
        post "/applications/#{application.token}/chats/#{chat.chat_number}/messages", params:  valid_params, as: :json
        puts response.body
        expect(response).to have_http_status(:success)
      end
    end


    context 'with invalid params' do
      it 'does not create a new message' do
        expect {
          post "/applications/#{application.token}/chats/#{chat.chat_number}/messages", params: invalid_params, as: :json
        }.to_not change(Message, :count)
      end

      it 'returns a bad request response' do
        post "/applications/#{application.token}/chats/#{chat.chat_number}/messages", params: invalid_params, as: :json
        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  describe 'GET #index' do
    let(:chat) { chats(:one) }
    let(:application) { applications(:one) }

    it 'returns a success response' do
      get "/applications/#{application.token}/chats/#{chat.chat_number}/messages/1"
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #show' do
    let(:application) { applications(:one) }
    let(:chat) { chats(:one) }
    let(:message) { messages(:one) }

    it 'returns a success response' do
      get "/applications/#{application.token}/chats/#{chat.chat_number}/messages/1"
      expect(response).to have_http_status(:success)
    end

    it 'returns the requested message' do
      get "/applications/#{application.token}/chats/#{chat.chat_number}/messages/1"
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['sender']).to eq(message.sender)
      expect(parsed_response['content']).to eq(message.content)
      expect(parsed_response['message_number']).to eq(message.message_number)
    end

    context 'when the message does not exist' do
      it 'returns a bad request response' do
        get "/applications/#{application.token}/chats/#{chat.chat_number}/messages/10"
        expect(response).to have_http_status(:bad_request)
      end
    end
  end
end
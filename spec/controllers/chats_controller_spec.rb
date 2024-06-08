require 'rails_helper'

RSpec.describe ChatsController, type: :request do
  fixtures :applications, :chats
  before do
    allow(REDIS).to receive(:exists).and_return(true)
    allow(REDIS).to receive(:set).and_return(true)
    allow(REDIS).to receive(:incr).and_return(4)
    allow(PUBLISHER).to receive(:publish_message).and_return(true)
  end

  describe 'POST #create' do
    let(:application) { applications(:one) }
    let(:valid_params) { { name: 'Chat1' } }
    let(:invalid_params) { { name: '' } }

    context 'with valid params' do
      it 'creates a new chat' do
        post "/applications/#{application.token}/chats", params: valid_params, as: :json
        expect(JSON.parse(response.body)["chat_number"]).to eq(4)
      end

      it 'returns a success response' do
        post "/applications/#{application.token}/chats", params: valid_params, as: :json
        expect(response).to have_http_status(:success)
      end
    end

    context 'with invalid params' do
      it 'does not create a new chat' do
        expect {
          post "/applications/#{application.token}/chats", params: invalid_params, as: :json
        }.to_not change(Chat, :count)
      end

      it 'returns a bad request response' do
        post "/applications/#{application.token}/chats", params: invalid_params, as: :json
        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  describe 'GET #index' do
    let(:application) { applications(:one) }

    it 'returns a success response' do
      get "/applications/#{application.token}/chats"
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #show' do
    let(:application) { applications(:one) }
    let(:chat) { chats(:one) }

    it 'returns a success response' do
      get "/applications/#{application.token}/chats/#{chat.chat_number}"
      expect(response).to have_http_status(:success)
    end

    context 'when the chat does not exist' do
      it 'returns a bad request response' do
        get "/applications/#{application.token}/chats/10"
        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  describe 'PUT #update' do
    let(:application) { applications(:one) }
    let(:chat) { chats(:one) }
    let(:valid_params) { { name: 'UpdatedChat' } }
    let(:invalid_params) { { name: '' } }

    context 'with valid params' do
      it 'updates the chat' do
        put "/applications/#{application.token}/chats/#{chat.chat_number}", params: valid_params, as: :json
        chat.reload
        expect(chat.name).to eq('UpdatedChat')
      end

      it 'returns a success response' do
        put "/applications/#{application.token}/chats/#{chat.chat_number}", params: valid_params, as: :json
        expect(response).to have_http_status(:success)
      end
    end

    context 'with invalid params' do
      it 'does not update the chat' do
        put "/applications/#{application.token}/chats/#{chat.chat_number}", params: invalid_params, as: :json
        chat.reload
        expect(chat.name).to_not eq('')
      end

      it 'returns a bad request response' do
        put "/applications/#{application.token}/chats/#{chat.chat_number}", params: invalid_params, as: :json
        expect(response).to have_http_status(:bad_request)
      end
    end
  end
end
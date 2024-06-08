require 'rails_helper'

RSpec.describe ApplicationsController, type: :request do
  fixtures :applications

  describe 'POST #create' do
    let(:valid_params) { { name: 'TestApp' } }
    let(:invalid_params) { { name: '' } }

    context 'with valid params' do
      it 'creates a new application' do
        expect {
          post "/applications", params: valid_params, as: :json
        }.to change(Application, :count).by(1)
      end

      it 'returns a success response' do
        post "/applications", params: valid_params, as: :json
        expect(response).to have_http_status(:success)
      end
    end

    context 'with invalid params' do
      it 'does not create a new application' do
        expect {
          post "/applications", params: invalid_params, as: :json
        }.to_not change(Application, :count)
      end

      it 'returns a bad request response' do
        post "/applications", params: invalid_params, as: :json
        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  describe 'GET #index' do
    it 'returns a success response' do
      get "/applications"
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #show' do
    let(:application) { applications(:one) }

    it 'returns a success response' do
      get "/applications/#{application.token}"
      expect(response).to have_http_status(:success)
    end

    context 'when the application does not exist' do
      it 'returns a bad request response' do
        get "/applications/nonexistenttoken"
        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  describe 'PUT #update' do
    let(:application) { applications(:one) }
    let(:valid_params) { { name: 'UpdatedApp' } }
    let(:invalid_params) { { name: '' } }

    context 'with valid params' do
      it 'updates the application' do
        put "/applications/#{application.token}", params: valid_params, as: :json
        application.reload
        expect(application.name).to eq('UpdatedApp')
      end

      it 'returns a success response' do
        put "/applications/#{application.token}", params: valid_params, as: :json
        expect(response).to have_http_status(:success)
      end
    end

    context 'with invalid params' do
      it 'does not update the application' do
        put "/applications/#{application.token}", params: invalid_params, as: :json
        application.reload
        expect(application.name).to_not eq('')
      end

      it 'returns a bad request response' do
        put "/applications/#{application.token}", params: invalid_params, as: :json
        expect(response).to have_http_status(:bad_request)
      end
    end
  end
end
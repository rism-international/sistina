require 'rails_helper'

RSpec.describe 'Codes API', type: :request do
  let!(:codes) {create_list(:code, 10)}
  let(:code_id) {codes.first.id}

  describe 'GET /codes' do
    before { get '/codes' }

    it 'returns codes' do
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /codes/:id' do
    before { get "/codes/#{code_id}" }

    context 'when the record exists' do
      it 'returns the code' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(code_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end
    context 'when the record does not exists' do
      let(:code_id) {0}

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Code/)
      end
    end
  end

  describe 'POST /codes' do
    let(:valid_attributes) { 
      { cs: '1', content: 'Something can be said', t_: 'Everything' } 
    }

    context 'when the request is valid' do
      before { post '/codes', params: valid_attributes }

      it 'creates a code' do
        expect(json['cs']).to eq('1')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post '/codes', params: { cs: '2' } }

      it 'returns a validation failure message' do
        expect(response.body)
          .to match(/Validation failed: Content can't be blank/)
      end
    end
  end

  describe 'PUT /codes/:id' do
    let(:valid_attributes) { { cs: '3' } }

    context 'when the record exists' do
      before { put "/codes/#{code_id}", params: valid_attributes }

      it 'updates the record' do
        expect(response.body).to be_empty
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end
  end

  describe 'DELETE /codes/:id' do
    before { delete "/codes/#{code_id}" }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end

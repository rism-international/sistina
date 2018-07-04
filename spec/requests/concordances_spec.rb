require 'rails_helper'

RSpec.describe 'Concordances API', type: :request do
  let!(:concordances) {create_list(:concordance, 10)}
  let(:concordance_id) {concordances.first.id}

  describe 'GET /concordances' do
    before { get '/concordances' }

    it 'returns concordances' do
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end

    it 'returns status concordance 200' do
      expect(response).to have_http_status(200)
    end
  end
  describe 'GET /concordances/:id' do
    before { get "/concordances/#{concordance_id}" }

    context 'when the record exists' do
      it 'returns the concordance' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(concordance_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end
    context 'when the record does not exists' do
      let(:concordance_id) {100}

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Concordance/)
      end
    end
  end

  describe 'POST /concordances' do
    let(:valid_attributes) { { nr: '1', ccd0: 'Something can be said' } }

    context 'when the request is valid' do
      before { post '/concordances', params: valid_attributes }

      it 'creates a concordance' do
        expect(json['nr']).to eq('1')
      end

      it 'returns status concordance 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post '/concordances', params: { nr: '2' } }

      it 'returns a validation failure message' do
        expect(response.body)
          .to match(/Validation failed: Ccd0 can't be blank/)
      end
    end
  end

  describe 'PUT /concordances/:id' do
    let(:valid_attributes) { { nr: '3' } }

    context 'when the record exists' do
      before { put "/concordances/#{concordance_id}", params: valid_attributes }

      it 'updates the record' do
        expect(response.body).to be_empty
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end
  end

  describe 'DELETE /concordances/:id' do
    before { delete "/concordances/#{concordance_id}" }

    it 'returns status concordance 204' do
      expect(response).to have_http_status(204)
    end
  end
end

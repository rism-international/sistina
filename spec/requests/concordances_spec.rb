require 'rails_helper'

RSpec.describe 'Concordances API' do
  let!(:code) { create(:code) }
  let(:code_id) { code.id }
  let!(:pieces) { create_list(:piece, 2, code_id: code.id) }
  let(:piece_id) { pieces.first.id }
  let!(:concordances) { create_list(:concordance, 12, piece_id: pieces.first.id) }
  let(:id) { concordances.first.id }

  describe 'GET /concordances' do
    before { get '/concordances' }

    it 'returns concordances' do
      expect(json).not_to be_empty
      expect(json.size).to eq(12)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end
  describe 'GET /concordances/:id' do
    before { get "/concordances/#{id}" }

    context 'when concordance exists' do
      it 'returns status concordance' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(id)
      end
      
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when concordance does not exist' do
      let(:id) {0}

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Concordance/)
      end
    end
  end
  describe 'POST /concordances' do
    let(:valid_attributes) { 
      { nr: '9876', ccd0: 'with the lights out, its less dagerous', title: 'Smells like teen spirit', piece_id: piece_id } 
    }

    context 'when the request is valid' do
      before { post "/concordances", params: valid_attributes }

      it 'creates a concordance' do
        expect(json['nr']).to eq(9876)
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post "/concordances", params: {} }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match(
            /Validation failed: Piece must exist, Nr can't be blank, Ccd0 can't be blank, Title can't be blank/
        )
      end
    end
  end

  describe 'PUT /concordances/:id' do
    let(:valid_attributes) { { 
      nr: '8234', 
      title: 'Hey Ya', 
      ccd0: 'you think you got it, ohh you think you got it' 
    } }

    before { put "/concordances/#{id}", params: valid_attributes }

    context 'when concordance exists' do
      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end


      it 'updates concordance' do
        expect(response.body).to be_empty
      end
    end
  end

  describe 'DELETE /concordances/:id' do
    before { delete "/concordances/#{id}" }

    it 'returns status piece 204' do
      expect(response).to have_http_status(204)
    end
  end
end

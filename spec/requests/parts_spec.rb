require 'rails_helper'

RSpec.describe 'Parts API' do
  let!(:code) { create(:code) }
  let(:code_id) { code.id }
  let!(:pieces) { create_list(:piece, 2, code_id: code.id) }
  let(:piece_id) { pieces.first.id }
  let!(:parts) { create_list(:part, 5, piece_id: pieces.first.id) }
  let(:id) { parts.first.id }

  describe 'GET /parts' do
    before { get '/parts' }

    it 'returns parts' do
      expect(json).not_to be_empty
      expect(json.size).to eq(5)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end
  describe 'GET /parts/:id' do
    before { get "/parts/#{id}" }

    context 'when part exists' do
      it 'returns status part' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(id)
      end
      
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when part does not exist' do
      let(:id) {0}

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Part/)
      end
    end
  end
  describe 'POST /parts' do
    let(:valid_attributes) { 
      { nr: '3030', composer: 'Nirvana', title: 'Smells like teen spirit', piece_id: piece_id } 
    }

    context 'when the request is valid' do
      before { post "/parts", params: valid_attributes }

      it 'creates a part' do
        expect(json['nr']).to eq(3030)
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post "/parts", params: {} }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match(
            /Validation failed: Piece must exist, Nr can't be blank, Title can't be blank, Composer can't be blank/
        )
      end
    end
  end

  describe 'PUT /parts/:id' do
    let(:valid_attributes) { { 
      nr: '1010', 
      title: 'Hey Ya', 
      composer: 'Outcast'
    } }

    before { put "/parts/#{id}", params: valid_attributes }

    context 'when part exists' do
      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end


      it 'updates part' do
        expect(response.body).to be_empty
      end
    end
  end

  describe 'DELETE /parts/:id' do
    before { delete "/parts/#{id}" }

    it 'returns status piece 204' do
      expect(response).to have_http_status(204)
    end
  end
end

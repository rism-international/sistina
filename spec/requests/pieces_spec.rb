require 'rails_helper'

RSpec.describe 'Pieces API' do
  let!(:code) { create(:code) }
  let!(:pieces) { create_list(:piece, 20, code_id: code.id) }
  let(:code_id) { code.id }
  let(:id) { pieces.first.id }

  describe 'GET /codes/:code_id/pieces' do
    before { get "/codes/#{code_id}/pieces" }

    context 'when code exists' do
      it 'returns staus code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns all pieces' do
        expect(json.size).to eq(20)
      end
    end

    context 'when code does not exist' do
      let(:code_id) {0}

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Code/)
      end
    end
  end
    
  describe 'GET /codes/:code_id/pieces/:id' do
    before { get "/codes/#{code_id}/pieces/#{id}" }

    context 'when code exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
      
      it 'returns the piece' do
        expect(json['id']).to eq(id)
      end
    end

    context 'when code does not exist' do
      let(:id) {0}

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Piece/)
      end
    end
  end

  describe 'POST /codes/:code_id/pieces' do
    let(:valid_attributes) { { cs: '1', nr: '2000', title: 'Canciones' } }

    context 'when the request is valid' do
      before { post "/codes/#{code_id}/pieces", params: valid_attributes }

      it 'returns status piece 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post "/codes/#{code_id}/pieces", params: {} }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match(/Validation failed: Nr can't be blank, Cs can't be blank, Title can't be blank/)
      end
    end
  end

  describe 'PUT /codes/:code_id/pieces/:id' do
    let(:valid_attributes) { { cs: '3', nr: '9393', title: 'Cantaten' } }

    before { put "/codes/#{code_id}/pieces/#{id}", params: valid_attributes }

    context 'when piece exist' do
      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end

      it 'updates piece' do
        updated_piece = Piece.find(id)
        expect(updated_piece.title).to match(/Cantaten/)
      end
    end

    context 'when piece does not exist' do
      let(:id) {0}

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Piece/)
      end
    end
  end


  describe 'DELETE /codes/:id' do
    before { delete "/codes/#{code_id}/pieces/#{id}" }

    it 'returns status piece 204' do
      expect(response).to have_http_status(204)
    end
  end
end

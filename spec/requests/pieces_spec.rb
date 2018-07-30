require 'rails_helper'

RSpec.describe 'Pieces API', type: :request do
  let!(:code) { create(:code) }
  let!(:code_id) { code.id }
  let!(:pieces) { create_list(:piece, 20, code_id: code_id) }
  let(:id) { pieces.first.id }

  describe 'GET /pieces' do
    before { get "/pieces" }

    it 'returns staus code 200' do
      expect(response).to have_http_status(200)
    end

    it 'returns all pieces' do
      expect(json.size).to eq(20)
    end
  end
    
  describe 'GET /pieces/:id' do
    before { get "/pieces/#{id}" }

    context 'when piece exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
      
      it 'returns the piece' do
        expect(json['id']).to eq(id)
      end
    end

    context 'when piece does not exist' do
      let(:id) {10000}

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Piece/)
      end
    end
  end

  describe 'POST /pieces' do
    let(:valid_attributes) { 
      { cs: '1', nr: '2000', title: 'Canciones' } 
    }

    context 'when the request is valid' do
      before { post "/pieces", params: valid_attributes }

      it 'returns status piece 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post "/pieces", params: {} }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match(
            /Validation failed: Code must exist, Nr can't be blank, Cs can't be blank, Title can't be blank/
                   )
      end
    end
  end

  describe 'PUT /pieces/:id' do
    let(:valid_attributes) { 
      { cs: '3', nr: '9393', title: 'Cantaten', code_id: code_id } 
    }

    context 'when piece exists' do
      before { put "/pieces/#{id}", params: valid_attributes }

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end

      it 'updates piece' do
        expect(response.body).to be_empty
      end
    end
  end

  describe 'DELETE /pieces/:id' do
    before { delete "/pieces/#{id}" }

    it 'returns status piece 204' do
      expect(response).to have_http_status(204)
    end
  end
end

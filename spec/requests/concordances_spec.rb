require 'rails_helper'

RSpec.describe 'Concordances API' do
  let!(:code) { create(:code) }
  let(:code_id) { code.id }
  let!(:pieces) { create_list(:piece, 2, code_id: code.id) }
  let(:piece_id) { pieces.first.id }
  let(:concordances) { create_list(:concordance, 40, piece_id: pieces.first.id) }
  let(:id) { concordances.first.id }

  describe 'GET /codes/:code_id/pieces/:piece_id/concordances' do
    before { get "/codes/#{code_id}/pieces/#{piece_id}/concordances" }

    context 'when code exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns all pieces' do
        expect(json.size).to eq(2)
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
 
    context 'when piece exists' do
      it 'returns staus code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns all concordances' do
        expect(json.size).to eq(40)
      end
    end

    context 'when piece does not exist' do
      let(:piece_id) {0}

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Piece/)
      end
    end
  end
    
  describe 'GET /codes/:code_id/pieces/:piece_id/concordances/:id' do
    before { get "/codes/#{code_id}/pieces/#{piece_id}/concordances/#{id}" }

    context 'when piece exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
      
      it 'returns the concordance' do
        expect(json['id']).to eq(id)
      end
    end

    context 'when piece does not exist' do
      let(:id) {0}

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Concordance/)
      end
    end
  end

  describe 'POST /codes/:code_id/pieces/:piece_id/concordances' do
    let(:valid_attributes) { { nr: '9876', ccd0: 'with the lights out, its less dagerous', title: 'Smells like teen spirit' } }

    context 'when the request is valid' do
      before { post "/codes/#{code_id}/pieces/#{piece_id}/concordances", params: valid_attributes }

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post "/codes/#{code_id}/pieces/#{piece_id}/concordances", params: {} }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match(/Validation failed: Nr can't be blank, Ccd0 can't be blank, Title can't be blank/)
      end
    end
  end

  describe 'PUT /codes/:code_id/pieces/:piece_id/concordances/:id' do
    let(:valid_attributes) { { nr: '8234', title: 'Hey Ya', ccd0: 'you think you got it, ohh you think you got it' } }

    before { put "/codes/#{code_id}/pieces/#{piece_id}/concordances/#{id}", params: valid_attributes }

    context 'when concordance exists' do
      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end

      it 'updates concordance' do
        updated_concordance = Concordance.find(id)
        expect(updated_concordance.title).to match(/Hey Ya/)
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


  describe 'DELETE /codes/:id/piece/:piece_id' do
    before { delete "/codes/#{code_id}/pieces/#{piece_id}/concordances/#{id}" }

    it 'returns status piece 204' do
      expect(response).to have_http_status(204)
    end
  end
end

require 'rails_helper'

RSpec.describe 'Units API', type: :request do
  let!(:code) { create(:code) }
  let!(:code_id) { code.id }
  let!(:units) { create_list(:unit, 20, code_id: code_id) }
  let(:id) { units.first.id }

  describe 'GET /units' do
    before { get "/units" }

    it 'returns staus code 200' do
      expect(response).to have_http_status(200)
    end

    it 'returns all units' do
      expect(json.size).to eq(20)
    end
  end
    
  describe 'GET /units/:id' do
    before { get "/units/#{id}" }

    context 'when unit exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
      
      it 'returns the unit' do
        expect(json['id']).to eq(id)
      end
    end

    context 'when unit does not exist' do
      let(:id) {10000}

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Unit/)
      end
    end
  end

  describe 'POST /units' do
    let(:valid_attributes) { 
      { cs: '1', comment0: 'Commentation', code_id: code_id } 
    }

    context 'when the request is valid' do
      before { post "/units", params: valid_attributes }

      it 'returns status unit 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post "/units", params: {} }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match(
            /Validation failed: Code must exist, Cs can't be blank, Comment0 can't be blank/
                   )
      end
    end
  end

  describe 'PUT /units/:id' do
    let(:valid_attributes) { 
      { cs: '3', comment0: 'Viele Cantaten zusammengebunden', code_id: code_id } 
    }

    context 'when unit exists' do
      before { put "/units/#{id}", params: valid_attributes }

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end

      it 'updates unit' do
        expect(response.body).to be_empty
      end
    end
  end

  describe 'DELETE /units/:id' do
    before { delete "/units/#{id}" }

    it 'returns status unit 204' do
      expect(response).to have_http_status(204)
    end
  end
end

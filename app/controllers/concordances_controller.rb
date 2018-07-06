class ConcordancesController < ApplicationController
  before_action :set_code
  before_action :set_code_piece
  before_action :set_code_piece_concordance, only: [:show, :update, :destroy]

  # GET /codes/:code_id/pieces/:pieces_id/concordances
  def index
    json_response(@piece.concordances)
  end

   # GET /codes/:code_id/pieces/:piece_id/concordances/:id
  def show
    json_response(@concordance)
  end
  
  # POST /codes/:code_id/pieces/:pieces_id/concordances
  def create
    @piece.concordances.create!(concordance_params)
    json_response(@piece, :created)
  end
  
  # PUT /code/:code_id/pieces/:pieces_id/concordances/:id
  def update
    @concordance.update(concordance_params)
    head :no_content
  end

  # DELETE /code/:code_id/pieces/:pieces_id/concordances/:id
  def destroy
    @concordance.destroy
    head :no_content
  end

  private
  
  def concordance_params
    params.permit(:nr, :ccd0, :title)
  end

  def pieces_params
    params.permit(:nr, :cs, :title)
  end

  def set_code
    @code = Code.find(params[:code_id])
  end

  def set_code_piece
    @piece = Piece.find(params[:piece_id])
  end

  def set_code_piece_concordance
    @concordance = @piece.concordances.find_by!(id: params[:id]) if @piece
  end
end


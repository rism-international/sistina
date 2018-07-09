class PiecesController < ApplicationController
  before_action :set_code
  before_action :set_code_piece, only: [:show, :update, :destroy]

  # GET /pieces
  def index
    json_response(@code.pieces)
  end

  # GET /pieces/:id
  def show
    json_response(@piece)
  end
  #
  # POST /pieces
  def create
    @piece.create!(piece_params)
    json_response(@piece, :created)
  end
  
  # PUT /pieces/:id
  def update
    @piece.update(piece_params)
    head :no_content
  end

  # DELETE /pieces/:id
  def destroy
    @piece.destroy
    head :no_content
  end

  private
  
  def piece_params
    params.permit(:cs, :nr, :title)
  end

  def set_code
    @code = Code.find(params[:code_id])
  end

  def set_code_piece
    @piece = @code.pieces.find_by!(id: params[:id]) if @code
  end
end


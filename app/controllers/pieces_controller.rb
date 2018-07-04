class PiecesController < ApplicationController
  before_action :set_piece, only: [:show, :update, :destroy]

  # GET /pieces
  def index
    @pieces = Piece.all
    json_response(@pieces)
  end

  # POST /pieces
  def create
    @piece = Piece.create!(piece_params)
    json_response(@piece, :created)
  end
  
  # GET /pieces/:id
  def show
    json_response(@piece)
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

  def set_piece
    @piece = Piece.find(params[:id])
  end
end


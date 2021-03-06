class PiecesController < ApplicationController
  before_action :set_piece, only: [:show, :update, :destroy]

  # GET /pieces
  def index
    @pieces = Piece.all
    json_response(@pieces)
  end

  # GET /pieces/:id
  def show
    json_response(@piece)
  end
  #
  # POST /pieces
  def create
    @piece = Piece.create!(piece_params)
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
    params.permit(
      :cs, :nr, :title, 
      :non0,
      :non1,
      :lit,
      :non2,
      :pages,
      :t_,
      :non3,
      :current,
      :non4,
      :non5,
      :nr0,
      :title0,
      :title1,
      :title2,
      :composer,
      :composer0
    )
  end

  def set_piece
    @piece = Piece.find(params[:nr])
  end
end


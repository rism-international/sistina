class ConcordancesController < ApplicationController
  before_action :set_concordance, only: [:show, :update, :destroy]

  def index
    @concordances = Concordance.all
    json_response(@concordances)
  end

  def create
    @concordance = Concordance.create!(concordance_params)
    json_response(@concordance, :created)
  end
  
  def show
    json_response(@concordance)
  end
  
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
    params.permit(:nr, :ccd0, :title, :piece_id)
  end

  def set_concordance
    @concordance = Concordance.find(params[:id])
  end
end


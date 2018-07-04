class ConcordancesController < ApplicationController
  before_action :set_concordance, only: [:show, :update, :destroy]

  # GET /concordances
  def index
    @concordances = Concordance.all
    json_response(@concordances)
  end

  # POST /concordances
  def create
    @concordance = Concordance.create!(concordance_params)
    json_response(@concordance, :created)
  end
  
  # GET /concordances/:id
  def show
    json_response(@concordance)
  end
  
  # PUT /concordances/:id
  def update
    @concordance.update(concordance_params)
    head :no_content
  end

  # DELETE /concordances/:id
  def destroy
    @concordance.destroy
    head :no_content
  end

  private
  
  def concordance_params
    params.permit(:nr, :ccd0, :title)
  end

  def set_concordance
    @concordance = Concordance.find(params[:id])
  end
end


class UnitsController < ApplicationController
  before_action :set_unit, only: [:show, :update, :destroy]

 # GET /units
  def index
    @units = Unit.all
    json_response(@units)
  end

  # GET /units/:id
  def show
    json_response(@unit)
  end
  #
  # POST /units
  def create
    @unit = Unit.create!(unit_params)
    json_response(@unit, :created)
  end
  
  # PUT /units/:id
  def update
    @unit.update(unit_params)
    head :no_content
  end

  # DELETE /units/:id
  def destroy
    @unit.destroy
    head :no_content
  end

  private
  
  def unit_params
    params.permit(
      :t_,
      :material,
      :comment0,
      :cs, :comment0,
      :comment1,
      :pages,
      :comment2,
      :unit_nr,
      :comment3,
      :notation,
      :non0,
      :comment5,
      :comment6,
      :comment7,
      :owner,
      :non1,
      :size,
      :non2,
      :color0,
      :color1,
      :color2,
      :color3,
      :non3,
      :comment8
                 )
  end

  def set_unit
    @unit = Unit.find(params[:id])
  end
end


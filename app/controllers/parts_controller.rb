class PartsController < ApplicationController
  before_action :set_part, only: [:show, :update, :destroy]

  def index
    @parts = Part.all
    json_response(@parts)
  end

  def create
    @part = Part.create!(part_params)
    json_response(@part, :created)
  end

  def show
    json_response(@part)
  end

  def update
    @part.update(part_params)
    head :no_content
  end

  def destroy
    @part.destroy
    head :no_content
  end

  private

  def part_params
    params.permit(
      :nr, 
      :part_nr,
      :part_fol,
      :title, 
      :composer,
      :textincipit,
      :voices,
      :comment
    )
  end

  def set_part
    @part = Part.find(params[:id])
  end
end

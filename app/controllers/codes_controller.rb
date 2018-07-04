class CodesController < ApplicationController
  before_action :set_code, only: [:show, :update, :destroy]

  # GET /codes
  def index
    @codes = Code.all
    json_response(@codes)
  end

  # POST /codes
  def create
    @code = Code.create!(code_params)
    json_response(@code, :created)
  end
  
  # GET /codes/:id
  def show
    json_response(@code)
  end
  
  # PUT /codes/:id
  def update
    @code.update(code_params)
    head :no_content
  end

  # DELETE /codes/:id
  def destroy
    @code.destroy
    head :no_content
  end

  private
  
  def code_params
    params.permit(:cs, :content, :t_)
  end

  def set_code
    @code = Code.find(params[:id])
  end
end


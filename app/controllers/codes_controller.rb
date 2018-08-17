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
    params.permit(
      :cs, :content, :t_,
      :material,
      :n_,
      :size,
      :place,
      :date,
      :owner0,
      :title_comment,
      :binding_comment,
      :pagenumbering,
      :non10,
      :non0,
      :non4,
      :comment0,
      :non1,
      :non2,
      :comment1,
      :non11,
      :notation,
      :non3,
      :owner1,
      :non12,
      :non5,
      :non13,
      :non6,
      :comment2,
      :non7,
      :libsig,
      :lit,
      :non14,
      :non8,
      :sig0,
      :non15,
      :non9,
      :sig1,
      :sig2,
      :comment3  
    )
  end

  def set_code
    @code = Code.find(params[:cs])
  end
end


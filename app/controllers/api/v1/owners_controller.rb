class Api::V1::OwnersController < ApplicationController
  def index
    @owners = Owner.all
  end

  def create
    @owner = Owner.new(owner_params)

    unless @owner.save
      render json: { errors: @owner.errors.full_messages }, status: :unprocessable_entity
    else
      render json: @owner, status: :created
    end
  end

  def show
    owner_id = params[:id].to_i
    @owner = Owner.find_by(id: owner_id)

    if @owner.nil?
      render status: :not_found
    end
  end

  private

  def owner_params
    params.require(:owner).permit(:name, :email, :phone)
  end
end

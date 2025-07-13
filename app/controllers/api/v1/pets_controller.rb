class Api::V1::PetsController < ApplicationController
  rescue_from ArgumentError, with: :handle_argument_error

  def index
    @pets = Pet.all

    if params.key?(:in_zone)
      in_zone_value = params[:in_zone].to_boolean
      @pets = @pets.where(in_zone: in_zone_value)
    end
  end

  def create
    @pet = Pet.new(pet_params)

    if @pet.save
      Rails.cache.delete("outside_zone_count") if @pet.in_zone == false
    else
      render json: { errors: @pet.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def outside_zone_count
    @result = Rails.cache.fetch("outside_zone_count", expires_in: 5.minutes) do
      counts = Pet.where(in_zone: false)
                .group(:pet_type, :tracker_type)
                .count

      counts.map do |(pet_type, tracker_type), count|
        {
          pet_type: pet_type,
          tracker_type: tracker_type,
          count: count
        }
      end
    end
  end

  private

  def pet_params
    params.require(:pet).permit(:pet_type, :tracker_type, :owner_id, :in_zone, :lost_tracker)
  end

  def handle_argument_error(exception)
    render json: { errors: [ exception.message ] }, status: :unprocessable_entity
  end
end

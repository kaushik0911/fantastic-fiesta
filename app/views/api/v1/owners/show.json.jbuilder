if @owner.present?
  json.owner do
    json.id @owner.id
    json.name @owner.name
    json.email @owner.email
    json.phone @owner.phone
    json.created_at @owner.created_at
    json.updated_at @owner.updated_at

    json.pets @owner.pets do |pet|
      json.id pet.id
      json.pet_type pet.pet_type
      json.tracker_type pet.tracker_type
      json.in_zone pet.in_zone
      json.lost_tracker pet.lost_tracker
      json.created_at pet.created_at
      json.updated_at pet.updated_at
    end
  end
end

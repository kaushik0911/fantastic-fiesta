json.array! @pets do |pet|
  json.id pet.id
  json.pet_type pet.pet_type
  json.tracker_type pet.tracker_type
  json.in_zone pet.in_zone
  json.lost_tracker pet.lost_tracker
  json.owner_id pet.owner_id
  json.created_at pet.created_at
  json.updated_at pet.updated_at
end

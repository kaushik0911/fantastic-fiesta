json.array! @result do |item|
  json.pet_type item[:pet_type]
  json.tracker_type item[:tracker_type]
  json.count item[:count]
end

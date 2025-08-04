json.array! @owners do |owner|
  json.id owner.id
  json.name owner.name
  json.email owner.email
  json.phone owner.phone
  json.created_at owner.created_at
  json.updated_at owner.updated_at
end

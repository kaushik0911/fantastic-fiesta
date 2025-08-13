PET_OUTSIDE_ZONE_COUNT = {
  type: :object,
  properties: {
    pet_type: { type: :string },
    tracker_type: { type: :string },
    count: { type: :integer, example: 5 }
  },
  required: [ 'pet_type', 'tracker_type', 'count' ],
  description: 'Count of pets outside a specific zone'
}.freeze

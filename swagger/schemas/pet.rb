PET = {
  type: :object,
  properties: {
    id: { type: :integer, example: 1 },
    pet_type: { type: :string, example: 'dog' },
    tracker_type: { type: :string, example: 'small' },
    in_zone: { type: :boolean, example: true },
    lost_tracker: { type: :boolean, example: false },
    created_at: { type: :string, format: 'date-time', example: '2023-10-01T12:00:00Z' },
    owner_id: { type: :integer, example: 1 },
    updated_at: { type: :string, format: 'date-time', example: '2023-10-01T12:00:00Z' }
  },
  required: [ 'id', 'pet_type', 'tracker_type', 'in_zone', 'lost_tracker', 'created_at', 'owner_id' ]
}.freeze

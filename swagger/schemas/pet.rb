PET = {
  type: :object,
  properties: {
    id: { type: :integer, example: 1 },
    pet_type: { type: :string, example: 'Dog' },
    tracker_type: { type: :string, example: 'GPS' },
    in_zone: { type: :boolean, example: true },
    lost_tracker: { type: :boolean, example: false },
    created_at: { type: :string, format: 'date-time', example: '2023-10-01T12:00:00Z' },
    updated_at: { type: :string, format: 'date-time', example: '2023-10-01T12:00:00Z' }
  },
  required: [ "id", "pet_type", "tracker_type", "in_zone", "lost_tracker", "created_at" ]
}.freeze

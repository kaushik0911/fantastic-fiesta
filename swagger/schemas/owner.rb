OWNER = {
  type: :object,
  properties: {
    id: { type: :integer, example: 1 },
    name: { type: :string, example: 'John Doe' },
    email: { type: :string, format: 'email', example: 'john.d@example.com' },
    phone: { type: :string, example: '123-456-7890' },
    created_at: { type: :string, format: 'date-time', example: '2023-10-01T12:00:00Z' }
  },
  required: [ 'id', 'name', 'email', 'phone', 'created_at' ]
}.freeze

PET_SHOW = {
  type: :object,
  properties: {
    pet: {
      type: :object,
      properties: PET[:properties].merge({
        pets: {
          type: :array,
          items: { '$ref' => '#/components/schemas/PET' }
        }
      })
    }
  },
  required: [ 'pet' ]
}.freeze

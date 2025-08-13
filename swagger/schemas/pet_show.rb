PET_SHOW = {
  type: :object,
  properties: {
    pet: {
      type: :object,
      properties: PET[:properties]
    }
  },
  required: [ 'pet' ]
}.freeze

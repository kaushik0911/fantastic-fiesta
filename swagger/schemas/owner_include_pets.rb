OWNER_INCLUDE_PETS = {
  type: :object,
  properties: {
    owner: {
      type: :object,
      properties: OWNER[:properties].merge({
        pets: {
          type: :array,
          items: { '$ref' => '#/components/schemas/PET' }
        }
      })
    }
  },
  required: [ "owner" ]
}.freeze

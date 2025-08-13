# spec/support/api_spec_helpers.rb
module ApiSpecHelpers
  extend ActiveSupport::Concern

  included do
    let(:Authorization) { "#{auth_headers['Authorization']}" }

    let(:pet_params) do
      {
        pet: {
          pet_type: 'dog',
          tracker_type: 'small',
          owner_id: Owner.create!(name: 'John Doe', email: 'jhon@example.com', phone: '123-456-7890').id,
          in_zone: false,
          lost_tracker: false
        }
      }
    end

    let(:invalid_pet_params) do
      {
        pet: {
          pet_type: 'cat',
          tracker_type: 'medium', # this is an invalid value
          owner_id: 1,
          in_zone: true,
          lost_tracker: false
        }
      }
    end

    let(:owner_params) do
      {
        owner: {
          name: 'Jane Doe',
          email: 'jane@example.com',
          phone: '123-456-7890'
        }
      }
    end

    let(:invalid_owner_params) do
      {
        owner: {
          name: 'Jane Doe',
          email: 'jane#example.com',
          phone: '123-456-7890'
        }
      }
    end
  end
end

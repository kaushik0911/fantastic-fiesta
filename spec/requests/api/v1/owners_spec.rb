# spec/requests/api/v1/owners_spec.rb
require 'rails_helper'

RSpec.describe 'api/v1/owners', type: :request do
  describe "GET /api/v1/owners" do
    path '/api/v1/owners' do
      get 'Retrieves a list of all owners' do
        tags 'Owners'
        security [ token_auth: [] ]
        produces 'application/json'

        response '200', 'successful' do
          schema type: :array, items: { '$ref' => '#/components/schemas/Owner' }
          run_test!
        end
      end
    end

    it "gets a list of owners" do
      get api_v1_owners_path, headers: auth_headers, as: :json

      expect(response).to have_http_status(:success)

      body = JSON.parse(response.body)
      expect(body).to be_a_kind_of(Array)
    end
  end

  describe "POST /api/v1/owners" do
    path '/api/v1/owners' do
      post 'Creates a new owner' do
        tags 'Owners'
        security [ token_auth: [] ]
        consumes 'application/json'
        produces 'application/json'

        parameter name: :owner_params, in: :body, schema: {
          type: :object,
          properties: {
            name: { type: :string, example: 'Jane Doe' },
            email: { type: :string, format: 'email', example: 'Jane@example.com' },
            phone: { type: :string, example: '123-456-7890' }
          },
          required: %w[name email phone]
        }

        response '201', 'Created' do
          schema '$ref' => '#/components/schemas/Owner'
          run_test!
        end

        response '422', 'Unprocessable Entity' do
          schema type: :object,
                  properties: {
                    errors: {
                      type: :array, items: { type: :string }
                    }
                  }
          run_test!
        end
      end
    end
  end
  describe "GET /api/v1/owners/:id" do
    path '/api/v1/owners/{id}' do
      get 'Retrieves a specific owner' do
        tags 'Owner'
        security [ token_auth: [] ]
        produces 'application/json'

        parameter name: 'id', in: :path, type: :integer, description: 'Owner ID'

        response '200', 'successful' do
          schema '$ref' => '#/components/schemas/Owner'
          run_test!
        end

        response '404', 'not found' do
          run_test!
        end
      end
    end
  end
end

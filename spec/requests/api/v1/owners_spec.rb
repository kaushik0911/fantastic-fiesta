# spec/requests/api/v1/owners_spec.rb
require 'rails_helper'
require 'swagger_helper'

RSpec.describe 'api/v1/owners', type: :request do
  describe "GET /api/v1/owners" do
    path '/api/v1/owners' do
      get 'Retrieves a list of all owners' do
        tags 'Owners'
        consumes 'application/json'
        produces 'application/json'

        response '200', 'successful' do
          schema type: :array, items: { '$ref' => '#/components/schemas/OWNER' }
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
        parameter name: :params, in: :body, schema: {
          type: :object,
          properties: {
            name: { type: :string, example: 'Jane Doe' },
            email: { type: :string, format: 'email', example: 'Jane@example.com' },
            phone: { type: :string, example: '123-456-7890' }
          },
          required: %w[name email phone]
        }

        response '201', 'Created' do
          let(:params) { owner_params }
          schema '$ref' => '#/components/schemas/OWNER'
          run_test!
        end

        response '422', 'Unprocessable Entity' do
          let(:params) { invalid_owner_params }
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

    it "create a new owners" do
      expect {
        post api_v1_owners_path, headers: auth_headers, params: owner_params, as: :json
      }.to change { Owner.count }.by(1)

      expect(response).to have_http_status(:created)
      body = JSON.parse(response.body)
      expect(body['name']).to eq(owner_params[:owner][:name])
      expect(body['email']).to eq('jane@example.com')
      expect(body['phone']).to eq(owner_params[:owner][:phone])
    end

    it "returns an error when creating an owner with invalid params" do
      expect {
        post api_v1_owners_path, headers: auth_headers, params: invalid_owner_params, as: :json
      }.not_to change { Owner.count }

      expect(response).to have_http_status(:unprocessable_entity)
      body = JSON.parse(response.body)
      expect(body['errors']).to include("Email is invalid")
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
          let(:id) { Owner.create!(owner_params[:owner]).id }
          schema '$ref' => '#/components/schemas/OWNER_SHOW'
          run_test!
        end

        response '404', 'not found' do
          let(:id) { 1_000_000 } # Assuming this ID does not exist
          run_test!
        end
      end
    end

    it "shows a specific owner" do
      owner = Owner.create!(owner_params[:owner])
      get api_v1_owner_path(owner.id), headers: auth_headers, as: :json

      expect(response).to have_http_status(:success)
      body = JSON.parse(response.body)
      expect(body['owner']['id']).to eq(owner.id)
      expect(body['owner']['name']).to eq(owner.name)
      expect(body['owner']['email']).to eq(owner.email)
      expect(body['owner']['phone']).to eq(owner.phone)
      expect(body['owner']['created_at']).to be_present
      expect(body['owner']['updated_at']).to be_present
      expect(body['owner']['pets']).to be_a_kind_of(Array)
    end
  end
end

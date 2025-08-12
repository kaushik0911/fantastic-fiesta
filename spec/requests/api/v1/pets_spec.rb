# spec/requests/api/v1/pets_spec.rb
require 'rails_helper'
require 'swagger_helper'

RSpec.describe "Api::V1::Pets", type: :request do
  let(:Authorization) { "#{auth_headers['Authorization']}" }

  let(:pet_params) do
    {
      pet: {
        pet_type: "dog",
        tracker_type: "small",
        owner_id: Owner.create!(name: "John Doe", email: "jhon@emssaild.com", phone: "1234567890").id,
        in_zone: true,
        lost_tracker: false
      }
    }
  end

  let(:invalid_pet_params) do
    {
      pet: {
        pet_type: "cat",
        tracker_type: "medium", # this is an invalid value
        owner_id: 1,
        in_zone: true,
        lost_tracker: false
      }
    }
  end

  describe "GET /api/v1/pets" do
    path "/api/v1/pets" do
      get "Retrieves a list of all pets" do
        tags "Pets"
        consumes 'application/json'
        produces 'application/json'

        response "200", "successful" do
          schema type: :array, items: { '$ref' => '#/components/schemas/PET' }
          run_test!
        end
      end
    end

    it "gets a list of pets" do
      get api_v1_pets_path, headers: auth_headers, as: :json

      # Use `have_http_status` instead of `assert_response`
      expect(response).to have_http_status(:success)

      body = JSON.parse(response.body)

      # RSpec matchers: `be_a_kind_of` and `include`
      expect(body).to be_a_kind_of(Array)
    end
  end

  describe "GET /api/v1/pets/outside_zone_count" do
    path "/api/v1/pets/outside_zone_count" do
      get "Gets a count of pets outside their zone" do
        tags "Pets"
        produces "application/json"
        response "200", "successful" do
          schema type: :array, items: { '$ref' => '#/components/schemas/PET' }
          description "Returns a list of pets that are outside their designated zones"
          run_test!
        end
      end
    end

    it "gets a count of pets outside their zone" do
      get outside_zone_count_api_v1_pets_path, headers: auth_headers, as: :json
      expect(response).to have_http_status(:success)

      body = JSON.parse(response.body)

      # RSpec's `include` matcher can check for a specific hash within an array
      expect(body).to include(a_hash_including("pet_type" => "cat", "tracker_type" => "small"))
    end
  end

  describe "POST /api/v1/pets" do
    # Here's where Rswag documentation for this path would go
    path "/api/v1/pets" do
      post "Creates a new pet" do
        tags "Pets"
        consumes "application/json"
        produces "application/json"
        parameter name: :params, in: :body, schema: {
          type: :object,
          properties: {
            pet: {
              type: :object,
              properties: {
                pet_type: { type: :string },
                tracker_type: { type: :string },
                owner_id: { type: :integer },
                in_zone: { type: :boolean },
                lost_tracker: { type: :boolean }
              }
            }
          }
        }

        response "201", "Created" do
          let(:params) { pet_params }
          schema '$ref' => '#/components/schemas/PET'
          run_test!
        end

        response "422", "Unprocessable Entity" do
          let(:params) { invalid_pet_params }
          schema  type: :object,
                  properties: {
                    errors: {
                      type: :array, items: { type: :string }
                    }
                  }
          run_test!
        end
      end
    end

    it "creates a new pet" do
      expect {
        post api_v1_pets_path, headers: auth_headers, params: pet_params, as: :json
      }.to change { Pet.count }.by(1)

      expect(response).to have_http_status(:created)


      body = JSON.parse(response.body)
      expect(body["pet"]["pet_type"]).to eq("dog")
      expect(body["pet"]["tracker_type"]).to eq("small")
      expect(body["pet"]["in_zone"]).to be true
      expect(body["pet"]["lost_tracker"]).to be false
      expect(body["pet"]["owner_id"]).to eq(Owner.last.id)
    end

    # it "does not create an invalid pet" do
    #   # Use `change` with `expect` instead of `assert_difference`
    #   expect {
    #     post api_v1_pets_path, headers: auth_headers, params: pet_params, as: :json
    #   }.to_not change(Pet, :count)

    #   expect(response).to have_http_status(:unprocessable_entity)

    #   body = JSON.parse(response.body)

    #   # Use `include` or `match` for string assertions
    #   expect(body["errors"].join).to include("'large' is not a valid tracker_type")
    # end
  end
end

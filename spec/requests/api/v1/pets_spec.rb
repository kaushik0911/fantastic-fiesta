# spec/requests/api/v1/pets_spec.rb
require 'rails_helper'

RSpec.describe "Api::V1::Pets", type: :request do
  # Use `let` to define instance variables like `@pet`
  let(:pet) { pets(:my_pet) }

  describe "GET /api/v1/pets" do
    path "/api/v1/pets" do
      get "Retrieves a list of all pets" do
        tags "Pets"
        security [ token_auth: [] ]
        produces "application/json"
        response "200", "successful" do
          schema type: :array, items: { '$ref' => '#/components/schemas/Pets' }
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
      expect(body).to include(a_hash_including("id" => pet.id))
    end
  end

  # The second test for a different endpoint is a separate `describe` block
  describe "GET /api/v1/pets/outside_zone_count" do
    # Here's where Rswag documentation for this path would go
    # path "/api/v1/pets/outside_zone_count" do
    #   get "Gets a count of pets outside their zone" do
    #     tags "Pets"
    #     produces "application/json"
    #     response "200", "successful" do
    #       run_test!
    #     end
    #   end
    # end

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
        security [ token_auth: [] ]
        consumes "application/json"
        produces "application/json"
        parameter name: :pet_params, in: :body, schema: {
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
          run_test!
        end

        response "422", "Unprocessable Entity" do
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
      pet_params = {
        pet: {
          pet_type: "dog",
          tracker_type: "large",
          owner_id: 1,
          in_zone: true,
          lost_tracker: false
        }
      }

      expect {
        post api_v1_pets_path, headers: auth_headers, params: pet_params, as: :json
      }.to change(Pet, :count).by(1)

      expect(response).to have_http_status(:created)

      body = JSON.parse(response.body)
      expect(body["pet"]["pet_type"]).to eq("dog")
      expect(body["pet"]["tracker_type"]).to eq("large")
      expect(body["pet"]["in_zone"]).to be true
      expect(body["pet"]["lost_tracker"]).to be false
      expect(body["pet"]["owner_id"]).to eq(1)
    end

    it "does not create an invalid pet" do
      pet_params = {
        pet: {
          pet_type: "cat",
          tracker_type: "medium", # this is an invalid value
          owner_id: 2,
          in_zone: true,
          lost_tracker: false
        }
      }

      puts "hi...."

      # Use `change` with `expect` instead of `assert_difference`
      expect {
        post api_v1_pets_path, headers: auth_headers, params: pet_params, as: :json
      }.to_not change(Pet, :count)

      expect(response).to have_http_status(:unprocessable_entity)

      body = JSON.parse(response.body)

      # Use `include` or `match` for string assertions
      expect(body["errors"].join).to include("cats cannot have medium tracker")
    end
  end
end

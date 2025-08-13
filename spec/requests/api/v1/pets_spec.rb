# spec/requests/api/v1/pets_spec.rb
require 'rails_helper'
require 'swagger_helper'

RSpec.describe "Api::V1::Pets", type: :request do
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

      expect(response).to have_http_status(:success)

      body = JSON.parse(response.body)

      expect(body).to be_a_kind_of(Array)
    end
  end

  describe "GET /api/v1/pets/outside_zone_count" do
    path "/api/v1/pets/outside_zone_count" do
      get "Gets a count of pets outside their zone" do
        tags "Pets"
        produces "application/json"
        response "200", "successful" do
          schema type: :array, items: { '$ref' => '#/components/schemas/PET_OUTSIDE_ZONE_COUNT' }
          description "Returns a list of pets that are outside their designated zones"
          run_test!
        end
      end
    end

    it "gets a count of pets outside their zone" do
      Pet.create!(pet_params[:pet])

      get outside_zone_count_api_v1_pets_path, headers: auth_headers, as: :json
      expect(response).to have_http_status(:success)

      body = JSON.parse(response.body)

      # RSpec's `include` matcher can check for a specific hash within an array
      expect(body).to be_a_kind_of(Array)
      expect(body).to include(hash_including({ "count" => 1, "pet_type" => "dog", "tracker_type" => "small" }))
      expect(body.size).to eq(1) # Assuming only one pet is outside the zone
    end
  end

  describe "POST /api/v1/pets" do
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
                pet_type: { type: :string, example: 'dog' },
                tracker_type: { type: :string, example: 'small' },
                owner_id: { type: :integer, example: 1 },
                in_zone: { type: :boolean, example: false },
                lost_tracker: { type: :boolean, example: false }
              }
            }
          }
        }

        response "201", "Created" do
          let(:params) { pet_params }
          schema '$ref' => '#/components/schemas/PET_SHOW'
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
      expect(body["pet"]["in_zone"]).to be false
      expect(body["pet"]["lost_tracker"]).to be false
      expect(body["pet"]["owner_id"]).to eq(Owner.last.id)
    end

    it "does not create an invalid pet" do
      expect {
        post api_v1_pets_path, headers: auth_headers, params: invalid_pet_params, as: :json
      }.to_not change(Pet, :count)

      expect(response).to have_http_status(:unprocessable_entity)

      body = JSON.parse(response.body)

      expect(body["errors"].join).to include("Tracker type cats cannot have medium tracker")
    end
  end
end

require "test_helper"

class PetsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @pet = Pet.create!(
      pet_type: :cat,
      tracker_type: :small,
      owner_id: 1,
      in_zone: false,
      lost_tracker: false
    )
  end

  test "should get index" do
    get pets_url, as: :json
    assert_response :success

    body = JSON.parse(response.body)
    assert body.is_a?(Array)
    assert body.any? { |p| p["id"] == @pet.id }
  end

  test "should get outside_zone_count" do
    get outside_zone_count_pets_url, as: :json
    assert_response :success

    body = JSON.parse(response.body)
    assert body.any? { |item| item["pet_type"] == "cat" and item["tracker_type"] == "small" }
  end

  test "should not create invalid pet" do
    pet_params = {
      pet: {
        pet_type: "cat",
        tracker_type: "medium", # this gonna be only small and big
        owner_id: 2,
        in_zone: true,
        lost_tracker: false
      }
    }

    assert_difference "Pet.count", 0 do
      post pets_url, params: pet_params, as: :json

      assert_response :unprocessable_entity

      body = JSON.parse(response.body)
      assert_includes body["errors"].join, "cats cannot have medium tracker"
    end
  end
end

require "test_helper"

class Api::V1::OwnersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @owner = owners(:me)
    @pet = pets(:my_pet)
  end

  test "should get index" do
    get api_v1_owners_url, headers: auth_headers, as: :json
    assert_response :success

    body = JSON.parse(response.body)

    assert body.is_a?(Array)
    assert body.any? { |o| o["id"] == @owner.id }
  end

  test "should give the my pet" do
    get api_v1_owner_url(@owner), headers: auth_headers, as: :json
    assert_response :success

    body = JSON.parse(response.body)
    pets = body["owner"]["pets"]

    assert pets.first { |p| p.id == @owner.pets.first[:id] }
    assert pets.is_a?(Array)
  end
end

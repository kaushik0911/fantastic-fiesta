require "test_helper"

class PetTest < ActiveSupport::TestCase
  def setup
    @pet = pets(:my_pet)
  end

  test "valid pet with correct attributes" do
    assert @pet.valid?
  end

  test "invalid pet without pet_type" do
    @pet.pet_type = nil
    assert_not @pet.valid?
    assert_includes @pet.errors[:pet_type], "can't be blank"
  end

  test "invalid pet without tracker_type" do
    @pet.tracker_type = nil
    assert_not @pet.valid?
    assert_includes @pet.errors[:tracker_type], "can't be blank"
  end

  test "invalid pet without owner_id" do
    @pet.owner_id = nil
    assert_not @pet.valid?
    assert_includes @pet.errors[:owner_id], "can't be blank"
  end

  test "pet in_zone must be true or false" do
    @pet.in_zone = nil
    assert_not @pet.valid?
    assert_includes @pet.errors[:in_zone], "is not included in the list"
  end

  test "pet lost_tracker must be true or false" do
    @pet.lost_tracker = nil
    assert_not @pet.valid?
    assert_includes @pet.errors[:lost_tracker], "is not included in the list"
  end

  test "cats cannot have medium tracker" do
    @pet.tracker_type = :medium
    assert_not @pet.valid?
    assert_includes @pet.errors[:tracker_type], I18n.t("activerecord.errors.models.pet.attributes.tracker_type.cats_cannot_have_medium_tracker")
  end

  test "dogs can have medium tracker" do
    @pet.pet_type = :dog
    @pet.tracker_type = :medium
    assert @pet.valid?
  end

  test "lost_tracker can only be true for cats" do
    @pet.pet_type = :dog
    @pet.lost_tracker = true
    assert_not @pet.valid?
    assert_includes @pet.errors[:lost_tracker], I18n.t("activerecord.errors.models.pet.attributes.lost_tracker.can_only_be_true_for_cats")
  end

  test "lost_tracker can be true for cats" do
    @pet.lost_tracker = true
    assert @pet.valid?
  end
end

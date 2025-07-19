require "test_helper"

class OwnerTest < ActiveSupport::TestCase
  def setup
    @owner = owners(:me)
  end

  test "valid owner with correct attributes" do
    assert @owner.valid?
  end

  test "valid owner without phone number" do
    @owner.phone = nil
    assert @owner.valid?
  end

  test "should not accept invalid email type" do
    @owner.email = "not_an_email"
    assert_not @owner.valid?
  end

  test "should not allow duplicate email address" do
    duplicate_owner = Owner.new(
      name: "Cowshik",
      email: @owner.email,
      phone: "1234567890"
    )
    assert_not duplicate_owner.valid?
    assert_includes duplicate_owner.errors[:email], "has already been taken"
  end
end

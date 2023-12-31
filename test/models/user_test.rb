require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "authenticate with wrong name returns nil" do
    User.create(name: "testuser", password: "testpassword", password_confirmation: "testpassword")
    assert_nil User.authenticate("wrongname", "testpassword")
  end

  test "authenticate with wrong password returns nil" do
    User.create(name: "testuser", password: "testpassword", password_confirmation: "testpassword")
    assert_nil User.authenticate("testuser", "wrongpassword")
  end

  test "authenticate with correct name and password returns an instance of User" do
    User.create(name: "testuser", password: "testpassword", password_confirmation: "testpassword")
    user = User.authenticate("testuser", "testpassword")
    assert_equal User, user.class
    assert_equal "testuser", user.name
  end
end

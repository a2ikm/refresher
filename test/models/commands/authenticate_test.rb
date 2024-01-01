require "test_helper"

class CommandsAuthenticateTest < ActiveSupport::TestCase
  test "returns nil for wrong name" do
    User.create(name: "testuser", password: "testpassword", password_confirmation: "testpassword")
    assert_nil Commands::Authenticate.run("wrongname", "testpassword")
  end

  test "returns nil for wrong password" do
    User.create(name: "testuser", password: "testpassword", password_confirmation: "testpassword")
    assert_nil Commands::Authenticate.run("testuser", "wrongpassword")
  end

  test "returns an instance of User for correct name and password" do
    User.create(name: "testuser", password: "testpassword", password_confirmation: "testpassword")
    user = Commands::Authenticate.run("testuser", "testpassword")
    assert_equal User, user.class
    assert_equal "testuser", user.name
  end
end

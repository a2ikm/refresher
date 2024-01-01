require "test_helper"

class CommandsAuthenticateTest < ActiveSupport::TestCase
  test "raises Commands::Authenticate::Failed for wrong name" do
    User.create(name: "testuser", password: "testpassword", password_confirmation: "testpassword")
    assert_raises Commands::Authenticate::Failed do
      Commands::Authenticate.run("wrongname", "testpassword")
    end
  end

  test "raises Commands::Authenticate::Failed for wrong password" do
    User.create(name: "testuser", password: "testpassword", password_confirmation: "testpassword")
    assert_raises Commands::Authenticate::Failed do
      Commands::Authenticate.run("testuser", "wrongpassword")
    end
  end

  test "returns an instance of User for correct name and password" do
    User.create(name: "testuser", password: "testpassword", password_confirmation: "testpassword")
    user = Commands::Authenticate.run("testuser", "testpassword")
    assert_equal User, user.class
    assert_equal "testuser", user.name
  end
end

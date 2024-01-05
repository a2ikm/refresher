require "test_helper"

class CommandsStartSessionTest < ActiveSupport::TestCase
  test "raises Commands::Authenticate::Failed for wrong name" do
    user = User.create(name: "testuser", password: "testpassword", password_confirmation: "testpassword")
    sessions_count = Session.count
    access_token_count = AccessToken.count
    refresh_token_count = RefreshToken.count

    assert_raises Commands::Authenticate::Failed do
      Commands::StartSession.run("wrongname", "testpassword")
    end
    assert_equal sessions_count, Session.count
    assert_equal access_token_count, AccessToken.count
    assert_equal refresh_token_count, RefreshToken.count
  end

  test "raises Commands::Authenticate::Failed for wrong password" do
    user = User.create(name: "testuser", password: "testpassword", password_confirmation: "testpassword")
    sessions_count = Session.count
    access_token_count = AccessToken.count
    refresh_token_count = RefreshToken.count

    assert_raises Commands::Authenticate::Failed do
      Commands::StartSession.run("testuser", "wronpassword")
    end
    assert_equal sessions_count, Session.count
    assert_equal access_token_count, AccessToken.count
    assert_equal refresh_token_count, RefreshToken.count
  end

  test "returns an instance of Commands::StartSession::Result for correct name and password" do
    user = User.create(name: "testuser", password: "testpassword", password_confirmation: "testpassword")
    sessions_count = Session.count
    access_token_count = AccessToken.count
    refresh_token_count = RefreshToken.count

    result = Commands::StartSession.run("testuser", "testpassword")
    assert_equal sessions_count + 1, Session.count
    assert_equal access_token_count + 1, AccessToken.count
    assert_equal refresh_token_count + 1, RefreshToken.count

    assert_equal Commands::StartSession::Result, result.class
    assert_equal "testuser", result.name
    assert_equal AccessToken.last.token, result.access_token
    assert_equal RefreshToken.last.token, result.refresh_token
  end
end

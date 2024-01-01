require "test_helper"

class CommandsStartSessionTest < ActiveSupport::TestCase
  test "raises RuntimeError for wrong name" do
    user = User.create(name: "testuser", password: "testpassword", password_confirmation: "testpassword")
    sessions_count = Session.count
    access_token_count = AccessToken.count

    assert_raises RuntimeError do
      Commands::StartSession.run("wrongname", "testpassword")
    end
    assert_equal sessions_count, Session.count
    assert_equal access_token_count, AccessToken.count
  end

  test "raises RuntimeError for wrong password" do
    user = User.create(name: "testuser", password: "testpassword", password_confirmation: "testpassword")
    sessions_count = Session.count
    access_token_count = AccessToken.count

    assert_raises RuntimeError do
      Commands::StartSession.run("testuser", "wronpassword")
    end
    assert_equal sessions_count, Session.count
    assert_equal access_token_count, AccessToken.count
  end

  test "returns an instance of Commands::StartSession::Result for correct name and password" do
    user = User.create(name: "testuser", password: "testpassword", password_confirmation: "testpassword")
    sessions_count = Session.count
    access_token_count = AccessToken.count

    result = Commands::StartSession.run("testuser", "testpassword")
    assert_equal sessions_count + 1, Session.count
    assert_equal access_token_count + 1, AccessToken.count

    assert_equal Commands::StartSession::Result, result.class
    assert_equal "testuser", result.name
    assert_equal AccessToken.last.token, result.access_token
  end
end

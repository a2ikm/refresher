require "test_helper"

class CommandsRefreshSessionTest < ActiveSupport::TestCase
  test "raises Commands::RefreshSession::Failed for wrong token" do
    access_token_count = AccessToken.count
    refresh_token_count = RefreshToken.count

    assert_raises Commands::RefreshSession::Failed do
      Commands::RefreshSession.run("wrongtoken")
    end
    assert_equal access_token_count, AccessToken.count
    assert_equal refresh_token_count, RefreshToken.count
  end

  test "returns an instance of Commands::RefreshSession::Result for valid token" do
    user = User.create(name: "testuser", password: "testpassword", password_confirmation: "testpassword")
    token = Commands::StartSession.run("testuser", "testpassword").refresh_token

    access_token_count = AccessToken.count
    refresh_token_count = RefreshToken.count

    result = Commands::RefreshSession.run(token)
    assert_equal access_token_count + 1, AccessToken.count
    assert_equal refresh_token_count + 1, RefreshToken.count

    assert_equal Commands::RefreshSession::Result, result.class
    assert_equal AccessToken.last.token, result.access_token
    assert_equal RefreshToken.last.token, result.refresh_token
  end
end

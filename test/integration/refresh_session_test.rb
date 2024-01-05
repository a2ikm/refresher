require "test_helper"

class RefreshSessionTest < ActionDispatch::IntegrationTest
  test "respond 400 if token parameter is not given" do
    post "/sessions/refresh", params: { token: nil }
    assert_response :bad_request
  end

  test "respond 401 if token parameter is invalid" do
    post "/sessions/refresh", params: { token: "wrongtoken" }
    assert_response :unauthorized
  end

  test "respond 401 if token is invalidated" do
    User.create(name: "testuser", password: "testpassword", password_confirmation: "testpassword")
    result = Commands::StartSession.run("testuser", "testpassword")

    RefreshToken.verify(result.refresh_token).invalidate!

    post "/sessions/refresh", params: { token: result.refresh_token }
    assert_response :unauthorized
  end

  test "respond 200 if token is valid" do
    User.create(name: "testuser", password: "testpassword", password_confirmation: "testpassword")
    result = Commands::StartSession.run("testuser", "testpassword")

    post "/sessions/refresh", params: { token: result.refresh_token }
    assert_response :ok
  end
end

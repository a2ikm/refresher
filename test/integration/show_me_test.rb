require "test_helper"

class ShowMeTest < ActionDispatch::IntegrationTest
  test "respond 400 if authorization header is not given" do
    post "/me", params: {}, headers: { "Authorization": nil }
    assert_response :bad_request
  end

  test "respond 400 if authorization header does not start with Bearer" do
    user = User.create(name: "testuser", password: "testpassword", password_confirmation: "testpassword")
    session = Session.create(user: user)
    access_token = AccessToken.issue(session)

    post "/me", params: {}, headers: { "Authorization": access_token.token }
    assert_response :bad_request
  end

  test "respond 401 if token in authorization header is wrong" do
    post "/me", params: {}, headers: { "Authorization": "Bearer wrongtoken" }
    assert_response :unauthorized
  end

  test "respond 401 if token in authorization header is expired" do
    user = User.create(name: "testuser", password: "testpassword", password_confirmation: "testpassword")
    session = Session.create(user: user)
    access_token = AccessToken.issue(session)

    # This update is just for test. `expired_at` must not be changed.
    access_token.update!(expired_at: Time.zone.now)

    post "/me", params: {}, headers: { "Authorization": "Bearer #{access_token.token}" }
    assert_response :unauthorized
  end

  test "respond 200 if authorization header is valid" do
    user = User.create(name: "testuser", password: "testpassword", password_confirmation: "testpassword")
    session = Session.create(user: user)
    access_token = AccessToken.issue(session)

    post "/me", params: {}, headers: { "Authorization": "Bearer #{access_token.token}" }
    assert_response :ok
  end
end

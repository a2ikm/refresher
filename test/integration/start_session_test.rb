require "test_helper"

class StartSessionTest < ActionDispatch::IntegrationTest
  test "respond 400 if name parameter is not given" do
    post "/sessions", params: { name: nil, password: "testpassword" }
    assert_response :bad_request
  end

  test "respond 400 if password parameter is not given" do
    post "/sessions", params: { name: "testuser", password: nil }
    assert_response :bad_request
  end

  test "respond 401 if name parameter is not invalid" do
    User.create(name: "testuser", password: "testpassword", password_confirmation: "testpassword")

    post "/sessions", params: { name: "wronguser", password: "testpassword" }
    assert_response :unauthorized
  end

  test "respond 401 if password parameter is not invalid" do
    User.create(name: "testuser", password: "testpassword", password_confirmation: "testpassword")

    post "/sessions", params: { name: "testuser", password: "wrongpassword" }
    assert_response :unauthorized
  end

  test "respond 200 if name and password are correct" do
    User.create(name: "testuser", password: "testpassword", password_confirmation: "testpassword")

    post "/sessions", params: { name: "testuser", password: "testpassword" }
    assert_response :ok
  end
end

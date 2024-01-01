require "test_helper"

class CreateSessionTest < ActionDispatch::IntegrationTest
  test "respond 400 if name parameter is not given" do
    post "/sessions", params: { name: nil, password: "testpassword" }
    assert_response :bad_request
  end

  test "respond 400 if password parameter is not given" do
    post "/sessions", params: { name: "testuser", password: nil }
    assert_response :bad_request
  end
end

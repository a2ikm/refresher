require "test_helper"

class SessionTest < ActiveSupport::TestCase
  test "start with wrong name raises an error" do
    user = User.create(name: "testuser", password: "testpassword", password_confirmation: "testpassword")
    sessions_count = Session.count
    access_token_count = AccessToken.count

    assert_raises RuntimeError do
      Session.start("wrongname", "testpassword")
    end
    assert_equal sessions_count, Session.count
    assert_equal access_token_count, AccessToken.count
  end

  test "start with wrong password raises an error" do
    user = User.create(name: "testuser", password: "testpassword", password_confirmation: "testpassword")
    sessions_count = Session.count
    access_token_count = AccessToken.count

    assert_raises RuntimeError do
      Session.start("testuser", "wronpassword")
    end
    assert_equal sessions_count, Session.count
    assert_equal access_token_count, AccessToken.count
  end

  test "start with correct name and password returns an instance of Session::Result" do
    user = User.create(name: "testuser", password: "testpassword", password_confirmation: "testpassword")
    sessions_count = Session.count
    access_token_count = AccessToken.count

    result = Session.start("testuser", "testpassword")
    assert_equal sessions_count + 1, Session.count
    assert_equal access_token_count + 1, AccessToken.count

    assert_equal Session::Result, result.class
    assert_equal "testuser", result.name
    assert_equal AccessToken.last.token, result.access_token
  end
end

require "test_helper"

class AccessTokenTest < ActiveSupport::TestCase
  test "issue returns an instance of AccessToken" do
    user = User.create(name: "testuser", password: "testpassword", password_confirmation: "testpassword")
    session = Session.create(user: user)

    access_token = AccessToken.issue(session)

    assert_equal AccessToken, access_token.class
    assert_equal session, access_token.session
    assert_equal String, access_token.token.class
    assert_equal 32, access_token.token.length
    assert_equal true, access_token.token.match?(/\A[a-zA-Z0-9]+\z/)
    assert_equal access_token.created_at + 1.minutes, access_token.expired_at
  end

  test "verify returns nil for unknown token" do
    assert_nil AccessToken.verify("unknowntoken")
  end

  test "verify returns nil for expired token" do
    user = User.create(name: "testuser", password: "testpassword", password_confirmation: "testpassword")
    session = Session.create(user: user)

    access_token = AccessToken.issue(session)

    travel_to(access_token.expired_at, with_usec: true) do
      assert_nil AccessToken.verify(access_token.token)
    end
  end

  test "verify returns an instance of AccessToken for valid token" do
    user = User.create(name: "testuser", password: "testpassword", password_confirmation: "testpassword")
    session = Session.create(user: user)

    access_token = AccessToken.issue(session)
    access_token.reload

    travel_to(access_token.expired_at - 1.second, with_usec: true) do
      assert_equal access_token, AccessToken.verify(access_token.token)
    end
  end

  test "expired? returns if AccessToken is expired or now" do
    user = User.create(name: "testuser", password: "testpassword", password_confirmation: "testpassword")
    session = Session.create(user: user)

    access_token = AccessToken.issue(session)

    travel_to(access_token.expired_at - 1.second, with_usec: true) do
      assert_not access_token.expired?
    end

    travel_to(access_token.expired_at, with_usec: true) do
      assert access_token.expired?
    end

    travel_to(access_token.expired_at + 1.second, with_usec: true) do
      assert access_token.expired?
    end
  end
end

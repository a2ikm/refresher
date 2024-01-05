require "test_helper"

class RefreshTokenTest < ActiveSupport::TestCase
  test "issue returns an instance of RefreshToken" do
    user = User.create(name: "testuser", password: "testpassword", password_confirmation: "testpassword")
    session = Session.create(user: user)

    refresh_token = RefreshToken.issue(session)

    assert_equal RefreshToken, refresh_token.class
    assert_equal session, refresh_token.session
    assert_equal String, refresh_token.token.class
    assert_equal 32, refresh_token.token.length
    assert_equal true, refresh_token.token.match?(/\A[a-zA-Z0-9]+\z/)
    assert_equal refresh_token.created_at + 1.day, refresh_token.expired_at
  end

  test "verify returns nil for unknown token" do
    assert_nil RefreshToken.verify("unknowntoken")
  end

  test "verify returns nil for expired token" do
    user = User.create(name: "testuser", password: "testpassword", password_confirmation: "testpassword")
    session = Session.create(user: user)

    refresh_token = RefreshToken.issue(session)

    travel_to(refresh_token.expired_at, with_usec: true) do
      assert_nil RefreshToken.verify(refresh_token.token)
    end
  end

  test "verify returns an instance of RefreshToken for valid token" do
    user = User.create(name: "testuser", password: "testpassword", password_confirmation: "testpassword")
    session = Session.create(user: user)

    refresh_token = RefreshToken.issue(session)
    refresh_token.reload

    travel_to(refresh_token.expired_at - 1.second, with_usec: true) do
      assert_equal refresh_token, RefreshToken.verify(refresh_token.token)
    end
  end

  test "expired? returns if RefreshToken is expired or now" do
    user = User.create(name: "testuser", password: "testpassword", password_confirmation: "testpassword")
    session = Session.create(user: user)

    refresh_token = RefreshToken.issue(session)

    travel_to(refresh_token.expired_at - 1.second, with_usec: true) do
      assert_not refresh_token.expired?
    end

    travel_to(refresh_token.expired_at, with_usec: true) do
      assert refresh_token.expired?
    end

    travel_to(refresh_token.expired_at + 1.second, with_usec: true) do
      assert refresh_token.expired?
    end
  end

  test "invalidated? returns if RefreshToken is invalidated" do
    user = User.create(name: "testuser", password: "testpassword", password_confirmation: "testpassword")
    session = Session.create(user: user)

    refresh_token = RefreshToken.issue(session)

    assert_not refresh_token.invalidated?

    refresh_token.invalidate!
    assert refresh_token.invalidated?
  end
end

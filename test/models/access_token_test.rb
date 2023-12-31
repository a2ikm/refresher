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
  end
end

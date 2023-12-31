class Session < ApplicationRecord
  belongs_to :user

  # TODO: This structure's name seems bad
  Result = Data.define(:name, :access_token)

  def self.start(name, password)
    # TODO: Tell runtime errors and invalid request errors

    user = User.authenticate(name, password)
    if user.nil?
      raise "Invalid name or password"
    end

    session = Session.create(user: user)
    if session.nil?
      raise "Could not create session"
    end

    access_token = AccessToken.issue(session)
    if access_token.nil?
      raise "Could not create access token"
    end

    return Result.new(name: user.name, access_token: access_token.token)
  end
end

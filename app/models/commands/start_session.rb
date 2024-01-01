module Commands::StartSession
  # TODO: This structure's name seems bad
  Result = Data.define(:name, :access_token)

  # @raise [Commands::Authenticate::Failed] raised if authentication failed
  def self.run(name, password)
    # TODO: Tell runtime errors and invalid request errors

    user = Commands::Authenticate.run(name, password)
    session = Session.create!(user: user)

    access_token = AccessToken.issue(session)
    if access_token.nil?
      raise "Could not create access token"
    end

    return Result.new(name: user.name, access_token: access_token.token)
  end
end

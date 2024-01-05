module Commands::StartSession
  Result = Data.define(:access_token, :refresh_token)

  # @raise [Commands::Authenticate::Failed] raised if authentication failed
  def self.run(name, password)
    user = Commands::Authenticate.run(name, password)
    session = Session.create!(user: user)
    access_token = AccessToken.issue(session)
    refresh_token = RefreshToken.issue(session)

    return Result.new(access_token: access_token.token, refresh_token: refresh_token.token)
  end
end

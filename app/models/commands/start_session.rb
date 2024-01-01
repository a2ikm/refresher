module Commands::StartSession
  Result = Data.define(:name, :access_token)

  # @raise [Commands::Authenticate::Failed] raised if authentication failed
  def self.run(name, password)
    user = Commands::Authenticate.run(name, password)
    session = Session.create!(user: user)
    access_token = AccessToken.issue(session)

    return Result.new(name: user.name, access_token: access_token.token)
  end
end

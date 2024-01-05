module Commands::RefreshSession
  class Failed < Commands::BaseError
  end

  Result = Data.define(:access_token, :refresh_token)

  # @raise [Commands::RefreshSession::Failed] raised if refresh session failed
  def self.run(token)
    refresh_token = RefreshToken.verify(token)
    if refresh_token.nil?
      raise Failed, "Invalid or expired token"
    end

    refresh_token.invalidate!

    session = refresh_token.session
    access_token = AccessToken.issue(session)
    refresh_token = RefreshToken.issue(session)

    return Result.new(access_token: access_token.token, refresh_token: refresh_token.token)
  end
end

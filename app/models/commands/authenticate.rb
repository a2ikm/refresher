module Commands::Authenticate
  class Failed < Commands::BaseError
  end

  # @raise [Commands::Authenticate::Failed] raised if authentication failed
  def self.run(name, password)
    user = User.find_by(name: name)
    if user.nil? || !user.authenticate(password)
      raise Failed, "Invalid name or password"
    else
      user
    end
  end
end

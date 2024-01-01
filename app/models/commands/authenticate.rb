module Commands::Authenticate
  def self.run(name, password)
    user = User.find_by(name: name)
    if user.nil? || !user.authenticate(password)
      nil
    else
      user
    end
  end
end

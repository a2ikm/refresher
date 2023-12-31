class AccessToken < ApplicationRecord
  belongs_to :session

  def self.issue(session)
    begin
      return AccessToken.create(session: session, token: SecureRandom.alphanumeric(32))
    rescue ActiveRecord::RecordNotUnique
      retry
    end
  end

  def self.verify(token)
    access_token = AccessToken.find_by(token: token)
    if access_token.nil?
      return nil
    end

    # TODO: Implement expiration

    access_token
  end
end

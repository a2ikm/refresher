class AccessToken < ApplicationRecord
  belongs_to :session

  def self.issue(session)
    begin
      return AccessToken.create(session: session, token: SecureRandom.alphanumeric(32))
    rescue ActiveRecord::RecordNotUnique
      retry
    end
  end
end

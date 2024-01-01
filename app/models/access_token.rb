class AccessToken < ApplicationRecord
  EXPIRES_IN_SECONDS = 1.minute

  belongs_to :session

  def self.issue(session)
    begin
      now = Time.zone.now

      return AccessToken.create(
        session: session,
        token: SecureRandom.alphanumeric(32),
        created_at: now,
        updated_at: now,
        expired_at: now + EXPIRES_IN_SECONDS,
      )
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

  def expired?
    expired_at <= Time.zone.now
  end
end

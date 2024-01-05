class RefreshToken < ApplicationRecord
  EXPIRES_IN_SECONDS = 1.day

  belongs_to :session

  def self.issue(session)
    begin
      now = Time.zone.now

      return RefreshToken.create(
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
    refresh_token = RefreshToken.find_by(token: token)
    if refresh_token.nil?
      return nil
    end

    if refresh_token.expired?
      return nil
    end

    if refresh_token.invalidated?
      return nil
    end

    refresh_token
  end

  def expired?
    expired_at <= Time.zone.now
  end

  def invalidate!
    update!(invalidated_at: Time.zone.now)
  end

  def invalidated?
    !!invalidated_at && invalidated_at <= Time.zone.now
  end
end

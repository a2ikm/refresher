class User < ApplicationRecord
  has_secure_password

  has_many :sessions, dependent: :destroy

  def self.authenticate(name, password)
    user = User.find_by(name: name)
    if user.nil? || !user.authenticate(password)
      nil
    else
      user
    end
  end
end

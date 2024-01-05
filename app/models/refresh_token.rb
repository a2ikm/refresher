class RefreshToken < ApplicationRecord
  belongs_to :session
end

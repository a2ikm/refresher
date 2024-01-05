class AddExpiredAtToRefreshTokens < ActiveRecord::Migration[7.1]
  def change
    add_column :refresh_tokens, :expired_at, :datetime
  end
end

class AddInvalidatedAtToRefreshTokens < ActiveRecord::Migration[7.1]
  def change
    add_column :refresh_tokens, :invalidated_at, :datetime
  end
end

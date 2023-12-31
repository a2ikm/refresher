class CreateAccessTokens < ActiveRecord::Migration[7.1]
  def change
    create_table :access_tokens do |t|
      t.references :session, null: false, foreign_key: true
      t.string :token

      t.timestamps
    end
    add_index :access_tokens, :token, unique: true
  end
end

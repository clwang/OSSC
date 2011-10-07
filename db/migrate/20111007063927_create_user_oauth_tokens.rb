class CreateUserOauthTokens < ActiveRecord::Migration
  def change
    create_table :user_oauth_tokens do |t|
      t.string :uid
      t.integer :user_id
      t.string :access_token
      t.string :access_secret
      t.timestamps
    end
  end
end

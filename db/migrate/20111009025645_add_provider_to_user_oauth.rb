class AddProviderToUserOauth < ActiveRecord::Migration
  def change
    add_column :user_oauth_tokens, :provider, :string
  end
end

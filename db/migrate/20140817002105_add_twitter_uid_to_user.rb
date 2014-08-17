class AddTwitterUidToUser < ActiveRecord::Migration
  def change
    add_column :users, :twitter_uid, :string
    add_index :users, :twitter_uid, unique: true
  end
end

class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.datetime :last_tweeted_at

      t.timestamps
    end
  end
end

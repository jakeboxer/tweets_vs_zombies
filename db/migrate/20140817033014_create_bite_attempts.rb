class CreateBiteAttempts < ActiveRecord::Migration
  def change
    create_table :bite_attempts do |t|
      t.integer :target_id, null: false
      t.integer :biter_id, null: false
      t.integer :result, null: false

      t.timestamps
    end

    add_index :bite_attempts, :target_id
    add_index :bite_attempts, :biter_id
    add_index :bite_attempts, :result
  end
end

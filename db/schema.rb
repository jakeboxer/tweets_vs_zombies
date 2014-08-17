# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140817033014) do

  create_table "bite_attempts", force: true do |t|
    t.integer  "target_id",  null: false
    t.integer  "biter_id",   null: false
    t.integer  "result",     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "bite_attempts", ["biter_id"], name: "index_bite_attempts_on_biter_id"
  add_index "bite_attempts", ["result"], name: "index_bite_attempts_on_result"
  add_index "bite_attempts", ["target_id"], name: "index_bite_attempts_on_target_id"

  create_table "users", force: true do |t|
    t.string   "username"
    t.datetime "last_tweeted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "twitter_uid"
    t.string   "consumer_key"
    t.string   "consumer_secret"
    t.string   "access_token"
    t.string   "access_token_secret"
  end

  add_index "users", ["twitter_uid"], name: "index_users_on_twitter_uid", unique: true

end

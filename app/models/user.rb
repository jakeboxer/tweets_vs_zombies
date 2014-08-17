class User < ActiveRecord::Base
  def self.from_omniauth(auth)
    where(twitter_uid: auth["uid"]).first || create_from_omniauth(auth)
  end

  def self.create_from_omniauth(auth)
    create! do |user|
      user.twitter_uid = auth["uid"]
      user.username    = auth["info"]["nickname"]
    end
  end
end

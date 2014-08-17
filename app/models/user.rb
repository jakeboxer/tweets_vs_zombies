class User < ActiveRecord::Base
  # Error raised if we have problems with credentials when trying to do Twitter
  # stuff.
  class TwitterCredentialsError < StandardError; end

  def self.from_omniauth(auth)
    if user = find_by(:twitter_uid, auth["uid"])
      user.update_access_token_from_omniauth(auth)
      user.save if user.changed?
    else
      user = create_from_omniauth(auth)
    end

    user
  end

  def self.create_from_omniauth(auth)
    create! do |user|
      user.twitter_uid = auth["uid"]
      user.username    = auth["info"]["nickname"]

      update_access_token_from_omniauth(user, auth)
    end
  end

  def twitter_client
    return @twitter_client if defined? @twitter_client

    if [access_token, access_token_secret, consumer_key, consumer_secret].any?(&:blank?)
      raise TwitterCredentialsError, "Can't load Twitter client for user #{id} because of missing credentials."
    end

    @twitter_client = Twitter::REST::Client.new do |config|
      config.access_token        = access_token
      config.access_token_secret = access_token_secret
      config.consumer_key        = consumer_key
      config.consumer_secret     = consumer_secret
    end
  end

  private



  def self.update_access_token_from_omniauth(user, auth)
    access_token = auth["extra"]["access_token"]
    consumer     = access_token.consumer

    user.access_token        = access_token.token
    user.access_token_secret = access_token.secret
    user.consumer_key        = consumer.key
    user.consumer_secret     = consumer.secret
  end
end

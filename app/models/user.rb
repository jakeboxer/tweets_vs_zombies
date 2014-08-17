class User < ActiveRecord::Base
  has_one :zombified_by,
    -> { where(result: "success") },
    class_name:  "BiteAttempt",
    foreign_key: "target_id"

  # Error raised if we have problems with credentials when trying to do Twitter
  # stuff.
  class TwitterCredentialsError < StandardError; end

  def self.from_omniauth(auth)
    if user = find_by(twitter_uid: auth["uid"])
      update_access_token_from_omniauth(user, auth)
      user.save if user.changed?
    else
      user = create_from_omniauth(auth)
    end

    user
  end

  def self.from_twitter(twitter_user)
    user = find_by(twitter_uid: twitter_user.id) || new
    update_from_twitter(user, twitter_user)
    user.save if user.changed?

    user
  end

  def self.create_from_omniauth(auth)
    create! do |user|
      user.twitter_uid = auth["uid"]
      user.username    = auth["info"]["nickname"]

      update_access_token_from_omniauth(user, auth)
    end
  end

  def awake?
    last_tweeted_at.nil? || last_tweeted_at > 12.hours.ago
  end

  def following?(user, client:)
    client.friendship(user.username, username).target.following?
  end

  def sync_with_twitter_if_necessary(client)
    if awake?
      self.last_tweeted_at = client.user_timeline(username).first.created_at
      save if changed?
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

  def zombie?
    zombified_by.present?
  end

  private

  def self.update_from_twitter(user, twitter_user)
    user.twitter_uid = twitter_user.id.to_s
    user.username    = twitter_user.screen_name
  end

  def self.update_access_token_from_omniauth(user, auth)
    access_token = auth["extra"]["access_token"]
    consumer     = access_token.consumer

    user.access_token        = access_token.token
    user.access_token_secret = access_token.secret
    user.consumer_key        = consumer.key
    user.consumer_secret     = consumer.secret
  end
end

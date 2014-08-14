class BitesController < ApplicationController
  def create
    user = User.find_by(:username, username)

    if user.nil?
      # Grab user from twitter
      user = User.create(:username => username) if twitter_user.present?
    end

    if user.present?
      if user.needs_twitter_check?
        # TODO(jakeboxer): Make sure this updates updated_at even when the
        # last_tweeted_at timestamp doesn't change
        user.last_tweeted_at = twitter_user.tweets.first.created_at
        user.save
      end

      if user.zombie?
        # "@user is already a zombie!"
      elsif logged_in?
        if twitter_user.followed_by?(current_user)
          if twitter_user.biteable?
            # Bite
          else
            # "@user has tweeted recently, wait until they fall asleep!"
          end
        else
          # "You can only bite people who follow you!""
        end
      else
        # Log in with twitter
      end
    else
      # "@user isn't a real user on twitter!"
    end
  end

  def new
  end

  private

  def sanitized_username
    @sanitized_username ||= params[:username].to_s.strip.sub(/^@/, "")
  end

  def twitter_user
    return @twitter_user if defined? @twitter_user
    @twitter_user = Twitter.get_user(sanitized_username)
  end
end

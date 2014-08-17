class BitesController < ApplicationController
  def create
    user = User.find_by(:username, sanitized_username)

    unless signed_in?
      session[:last_bite_attempt_path] = bites_path(username: sanitized_username)

      return render "bites/sign_in", :locals => {
        :user     => user,
        :username => sanitized_username
      }
    end

    user ||= User.from_twitter(current_user.twitter_client.user(sanitized_username))
    user.sync_with_twitter_if_necessary(current_user.twitter_client)

    friendship = current_user.twitter_client.friendship(current_user.username, sanitized_username)

    if user.biteable_by?(current_user, client: current_user.twitter_client)
      # Bite
    else
      return render "bites/failed", :locals => { :user => user }
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

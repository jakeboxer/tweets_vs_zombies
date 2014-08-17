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

    return render "bites/zombie_required" unless current_user.zombie?

    client = current_user.twitter_client

    user ||= User.from_twitter(client.user(sanitized_username))
    user.sync_with_twitter_if_necessary(client)

    attempt = BiteAttempt.attempt(current_user, user, client: client)

    if attempt.success?
      # Show successful bite
    else
      return render "bites/failed", :locals => { :attempt => attempt }
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

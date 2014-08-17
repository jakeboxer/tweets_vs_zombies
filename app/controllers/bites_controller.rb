class BitesController < ApplicationController
  def create
    # unless logged_in?
    session[:last_bite_attempt_path] = bites_path(username: sanitized_username) unless false

    user = User.find_by(:username, sanitized_username)

    render "bites/sign_in", :locals => {
      :user     => user,
      :username => sanitized_username
    }
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

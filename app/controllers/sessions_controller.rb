class SessionsController < ApplicationController
  def create
    user = User.from_omniauth(env["omniauth.auth"])

    session[:user_id] = user.id

    redirect_to session.delete(:last_bite_attempt_path) || root_path
  end
end

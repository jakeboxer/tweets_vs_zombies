class SessionsController < ApplicationController
  def create
    user = User.from_omniauth(env["omniauth.auth"])

    session[:user_id] = user.id

    redirect_to session.delete(:last_bite_attempt_path) || root_path
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: "I wouldn't leave if I were you. DOS is much worse."
  end
end

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from Twitter::Error, with: :twitter_error

  def current_user
    @current_user ||= session[:user_id].present? && User.find(session[:user_id])
  end
  helper_method :current_user

  def signed_in?
    current_user.present?
  end
  helper_method :signed_in?

  private

  def twitter_error(error)
    render "/twitter_error", locals: { :error => error }
  end
end

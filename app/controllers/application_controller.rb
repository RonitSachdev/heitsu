class ApplicationController < ActionController::Base
  # Allow all browsers for mobile compatibility and dev tools testing
  # allow_browser versions: :modern

  before_action :require_login
  helper_method :current_user, :logged_in?

  private

  def current_user
    return nil unless session[:user_id]

    @current_user ||= begin
      User.find(session[:user_id])
    rescue ActiveRecord::RecordNotFound
      # Clear invalid session if user doesn't exist
      session[:user_id] = nil
      nil
    end
  end

  def logged_in?
    !!current_user
  end

  def require_login
    unless logged_in?
      flash[:alert] = "Please log in to access this page"
      redirect_to login_path
    end
  end

  def skip_login_required
    skip_before_action :require_login
  end
end

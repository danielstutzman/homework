class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :user_must_be_logged_in,
    except: [:login, :login_from_github, :logout, :github_webhook]

  protected
    def user_must_be_logged_in
      @user = User.find_by_id(session[:user_id])
      if @user.nil?
        redirect_to login_path and return false
      end
    end

    def user_must_be_admin
      if !@user.is_admin
        flash[:error] = 'You must be an admin to see this page'
        redirect_to login_path and return false
      end
    end
end

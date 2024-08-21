class SessionsController < ApplicationController
  layout "layouts/application_user"

  def new; end

  def create
    user = find_user_by_email
    if authenticate_user(user)
      handle_successful_login(user)
    else
      handle_failed_login
    end
  end

  def destroy
    log_out
    redirect_to root_url, status: :see_other
  end

  private

  def find_user_by_email
    User.find_by email: params.dig(:session, :email)&.downcase
  end

  def authenticate_user user
    user&.authenticate params.dig(:session, :password)
  end

  def handle_successful_login user
    reset_session
    log_in user
    redirect_to appropriate_path_for(user), status: :see_other
  end

  def appropriate_path_for user
    user.admin? ? admin_path : root_path
  end

  def handle_failed_login
    flash.now[:danger] = t "mess.invalid_email_password_combination"
    render :new, status: :unprocessable_entity
  end
end

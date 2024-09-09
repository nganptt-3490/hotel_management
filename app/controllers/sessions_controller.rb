class SessionsController < Devise::SessionsController
  skip_load_and_authorize_resource
  layout "application"
  def create
    super do |resource|
      flash[:notice] = t "welcome_first_time" if resource.sign_in_count == 1
    end
  end

  def destroy
    super do
      flash[:notice] = t "sign_out_success"
    end
  end

  private
  def after_sign_in_path_for resource
    appropriate_path_for resource
  end

  def appropriate_path_for resource
    resource.admin? ? admin_path : root_path
  end
end

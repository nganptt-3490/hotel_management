class ApplicationController < ActionController::Base
  include RoomTypesHelper
  include RequestsHelper
  include PriceFluctuationsHelper
  include Pagy::Backend
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_locale

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    {locale: I18n.locale}
  end

  private
  def logged_in_user
    return if user_signed_in?

    flash[:danger] = t "please_login"
    redirect_to login_url
  end

  protected
  def configure_permitted_parameters
    added_attrs = %i(email password password_confirmation remember_me)
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end
end

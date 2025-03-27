class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def authenticate_user!
    if devise_controller?
      super # ne pas bloquer les routes Devise
    elsif user_signed_in?
      super
    else
      redirect_to root_path
    end
  end

  def after_sign_in_path_for(resource)
    scan_path
  end

  # 👇 👇 👇 AJOUTE CECI
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:pseudo])
    devise_parameter_sanitizer.permit(:account_update, keys: [:pseudo])
  end
end

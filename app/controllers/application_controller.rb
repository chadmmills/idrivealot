class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :stripe_card_token
  end

  def after_sign_in_path_for(resource)
    if resource.is_a?(Admin)
      admin_users_path
    else
      mileage_records_path
    end
  end

end

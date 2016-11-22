class RegistrationsController < Devise::RegistrationsController
  before_filter :configure_permitted_parameters, if: :devise_controller?

  def create
    analytics_uuid = SegmentService.safe_get_analytics_uuid_from_cookies(cookies)
    params[:user][:analytics_uuid] = analytics_uuid
    super do |user|
      # Send Registration Event to Segment
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:email, :password, :password_confirmation, :analytics_uuid)
    end
  end
end


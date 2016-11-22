class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :set_analytics_uuid_on_cookies, unless: :user_signed_in?
  before_filter :authenticate_user!

  layout :layout_by_controller

  protected

  def layout_by_controller
    devise_controller? ? 'devise' : 'application'
  end

  private

  def set_analytics_uuid_on_cookies
    cookies[:analytics_uuid] ||= { value: SegmentService.generate_analytics_uuid, expires: 2.years.from_now }
    @analytics_uuid = cookies[:analytics_uuid]
  end
end

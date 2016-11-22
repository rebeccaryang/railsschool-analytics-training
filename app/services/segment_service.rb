class SegmentService
  def initialize(user)
    @user = user
    @analytics_uuid = @user.analytics_uuid
  rescue => e
    Rails.logger.info "SegmentService initialization failed with user: #{user&.id}, with error: #{e.message}."
  end

  def self.generate_analytics_uuid
    SecureRandom.uuid
  end

  def self.safe_get_analytics_uuid_from_cookies(cookies)
    # Created this in case multi user registration on the same device
    analytics_uuid = get_analytics_uuid_from_cookies(cookies)
    User.where(analytics_uuid: analytics_uuid).any? ? generate_analytics_uuid : analytics_uuid
  end

  def self.get_analytics_uuid_from_cookies(cookies)
    cookies[:analytics_uuid]
  end

  def send_segment_new_user_event
    event_params = {
      analytics_uuid: @analytics_uuid,
      event:          'Company Created',
      properties:     {
        company_id: @company.id
      }
    }
    send_event_to_segment(event_params)
  end

  def send_event_to_segment(event_params)
    Analytics.track(
      user_id:    event_params[:analytics_uuid],
      event:      event_params[:event],
      properties: event_params[:properties]
    )
    send_segment_identify_params
  rescue => e
    Rails.logger.info "Analytics Event failed with error #{e.message}"
  end

  def send_segment_identify_params(traits = nil)
    traits ||= identify_params[:traits]
    Analytics.identify(user_id: @analytics_uuid, traits: traits)
  rescue => e
    Rails.logger.info "Analytics Identify failed with error #{e.message}"
  end

  def identify_params
    {
      analytics_uuid: @analytics_uuid,
      traits:         {
        email: @user.email,
      }
    }
  end
end

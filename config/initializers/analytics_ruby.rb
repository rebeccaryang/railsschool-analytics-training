require 'segment/analytics'

# Analytics = Segment::Analytics.new({
#     write_key: 'YOUR_WRITE_KEY',
#     on_error: Proc.new { |status, msg| print msg }
# })

class Analytics
  attr_accessor :events, :identifies
  def initialize
    @events = []
    @identifies = []
  end

  def identify(params)
    identifies << params
  end

  def track(params)
    events << params
  end
end
# This module loading only for Rails apps
module SnowAgent
  class Railtie < Rails::Railtie
    initializer "snowagent.subscribe_notifications" do
      ActiveSupport::Notifications.subscribe /process_action.action_controller/ do |*args| 
        event = ActiveSupport::Notifications::Event.new(*args)
        duration = event.duration/1000.0

        # Send only 'request' metric for now
        SnowAgent.metric("request", duration, :request)
      end
    end
  end
end

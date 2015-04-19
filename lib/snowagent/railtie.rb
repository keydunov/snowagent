# This module loading only for Rails apps
module SnowAgent
  class Railtie < Rails::Railtie
    initializer "snowagent.subscribe_notifications" do
      ActiveSupport::Notifications.subscribe /process_action.action_controller/ do |*args| 
        event = ActiveSupport::Notifications::Event.new(*args)

        # Count only `html` GET requets
        if event.payload[:method] == "GET" && event.payload[:format] == :html
          duration = event.duration/1000.0
          SnowAgent.metric("Request", duration, :request)
        end
      end
    end
  end
end

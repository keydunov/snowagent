require "rails/railtie"

module SnowAgent
  class Railtie < Rails::Railtie
    initializer "snowagent.subscribe_notifications" do
      ActiveSupport::Notifications.subscribe /process_action.action_controller/ do |*args| 
        event = ActiveSupport::Notifications::Event.new(*args)
        controller = event.payload[:controller]
        action = event.payload[:action]
        duration = event.duration/1000.0

        SnowAgent.metric("#{controller}##{action}.total_time", duration, :specific_request)
        SnowAgent.metric("request", duration, :request)

        # TODO: don't send these metrics so frequent and so ugly
        SnowAgent.metric("controlles", ApplicationController.subclasses.size, :controllers)
        SnowAgent.metric("models", ActiveRecord::Base.subclasses.size, :models)
      end
    end
  end
end

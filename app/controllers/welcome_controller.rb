class WelcomeController < ApplicationController

  before_action :authorize!
  def index

  end

  def create
    require 'oauth/request_proxy/action_controller_request'
    @provider = IMS::LTI::ToolProvider.new(
        params[:oauth_consumer_key],
        Rails.configuration.lti_settings[params[:oauth_consumer_key]],
        params
    )

    if not @provider.valid_request?(request)
      # the request wasn't validated
      render :launch_error, status: 401
      return
    end
  end
end

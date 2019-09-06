class WelcomeController < ApplicationController

  def index
    before_action :authenticate_user!

  end

  def launch

    authenticator = IMS::LTI::Services::MessageAuthenticator.new(request.url, request.request_parameters, "FirstSecret")

    #Check if the signature is valid
    return false unless authenticator.valid_signature?

    # check if `params['oauth_nonce']` has already been used

    #check if the message is too old
    return false if DateTime.strptime(request.request_parameters['oauth_timestamp'],'%s') < 5.minutes.ago

  end


end


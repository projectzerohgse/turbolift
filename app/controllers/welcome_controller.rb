class WelcomeController < ApplicationController

  after_action :allow_iframe, only: [:show, :result, :launch, :complete]

  def allow_iframe
    response.headers.except! 'X-Frame-Options'
  end

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

    # raise params.inspect

    %w(custom_canvas_user_id custom_canvas_assignment_id custom_canvas_course_id).each { |v| session[v] = params[v] }

    session[:course_id] = params.require :custom_canvas_course_id
    session[:assignment_id] = params.require :custom_canvas_assignment_id
    session[:user_id] = params.require :custom_canvas_user_id
    @lis_course_id = session[:course_id]
    @lis_assignment_id = session[:assignment_id]
    @lis_user_id = session[:user_id]

    session[:lis_person_name_full] = params.require :lis_person_name_full
    @lis_person_name_full = session[:lis_person_name_full]

    redirect_to 'https://harvard.az1.qualtrics.com/jfe/form/SV_7aBwwslOEsvjCTj'

  end

  def complete

    canvas = Canvas::API.new(:host => "https://harvard-catalog-courses.instructure.com", :token => "4860~FxRNPxhS0CfekJsWBaidgK8ASZACEpwMWHKhsWCdCrRbAoP1kBfxIE4FdylhZ7Zi")
    url = "/api/v1/courses/#{session[:course_id]}/assignments/#{session[:assignment_id]}/submissions/#{session[:user_id]}?submission[posted_grade]=complete"
    canvas.put(url)

    @url = url
  end


end


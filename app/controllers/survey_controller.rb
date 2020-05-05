class SurveyController < ApplicationController

  after_action :allow_iframe, only: [:show, :result, :launch, :complete]

  def allow_iframe
    response.headers.except! 'X-Frame-Options'
  end

  def index
    before_action :authenticate_user!
  end

  def generate_url(url, params = {})
    uri = URI(url)
    uri.query = params.to_query
    uri.to_s
  end

  def launch

    authenticator = IMS::LTI::Services::MessageAuthenticator.new(request.url, request.request_parameters, "FirstSecret")

    #Check if the signature is valid
    return false unless authenticator.valid_signature?

    # check if `params['oauth_nonce']` has already been used

    #check if the message is too old
    return false if DateTime.strptime(request.request_parameters['oauth_timestamp'],'%s') < 5.minutes.ago

    # Save variables to session to be used later
    %w(custom_canvas_user_id custom_canvas_assignment_id custom_canvas_course_id).each { |v| session[v] = params[v] }

    session[:course_id] = params.require :custom_canvas_course_id
    session[:assignment_id] = params.require :custom_canvas_assignment_id
    session[:user_id] = params.require :custom_canvas_user_id
    # session[:lis_person_name_full] = params.require :lis_person_name_full

    # Check if User has submitted assignment
    canvas = Canvas::API.new(:host => "https://harvard-catalog-courses.instructure.com", :token => "4860~FxRNPxhS0CfekJsWBaidgK8ASZACEpwMWHKhsWCdCrRbAoP1kBfxIE4FdylhZ7Zi")
    url = "/api/v1/courses/#{session[:course_id]}/assignments/#{session[:assignment_id]}/submissions/#{session[:user_id]}?submission[posted_grade]=complete"
    response = canvas.get(url)

    @grade = response['grade']

    if(response['grade'] != 'complete')

       # Get course name
       url = "api/v1/courses/#{session[:course_id]}"
       response = canvas.get(url)
       course_name = response['name']
       redirect_to generate_url("https://harvard.az1.qualtrics.com/jfe/form/SV_a4ezn525A0CoS3P", :canvas_user_id => "#{session[:user_id]}", :canvas_course_id => "#{session[:course_id]}", :canvas_course_name => "#{course_name}")
    end

  end

  def complete
    canvas = Canvas::API.new(:host => "https://harvard-catalog-courses.instructure.com", :token => "4860~FxRNPxhS0CfekJsWBaidgK8ASZACEpwMWHKhsWCdCrRbAoP1kBfxIE4FdylhZ7Zi")
    url = "/api/v1/courses/#{session[:course_id]}/assignments/#{session[:assignment_id]}/submissions/#{session[:user_id]}?submission[posted_grade]=complete"
    canvas.put(url)

    @user = session[:user_id]
    reset_session
  end


end


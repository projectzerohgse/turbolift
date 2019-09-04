class ApplicationController < ActionController::Base

  def authorized?
    session.key?(:auth_hash)
  end

  def authorize!
    redirect_to "/auth/canvas" unless authorized?
  end
end

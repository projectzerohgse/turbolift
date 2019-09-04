class WelcomeController < ApplicationController

  def index

    $oauth_key = "d502eec9-2755-4c19-86b5-cebf38a5614a"
    $oauth_secret = "secret"

    begin
      signature = OAuth::Signature.build(request, :consumer_secret => $oauth_secret)
      signature.verify or raise OAuth::Unauthorized
    rescue OAuth::Signature::UnknownSignatureMethod,
        OAuth::Unauthorized
      return %{unauthorized attempt. make sure you used the consumer secret "#{$oauth_secret}"}
    end
  end

  def create

    $oauth_key = "d502eec9-2755-4c19-86b5-cebf38a5614a"
    $oauth_secret = "secret"

    begin
      signature = OAuth::Signature.build(request, :consumer_secret => $oauth_secret)
      signature.verify or raise OAuth::Unauthorized
    rescue OAuth::Signature::UnknownSignatureMethod,
        OAuth::Unauthorized
      return %{unauthorized attempt. make sure you used the consumer secret "#{$oauth_secret}"}
    end

  end
end

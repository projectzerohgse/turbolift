Rails.application.config.middleware.use OmniAuth::Builder do
  provider :canvas, "d502eec9-2755-4c19-86b5-cebf38a5614a", "secret", :setup => lambda{|env|
    env['omniauth.strategy'].options[:client_options].site = "https://harvard.instructure.com"
  }
end
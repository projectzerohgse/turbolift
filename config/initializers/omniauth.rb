Rails.application.config.middleware.use OmniAuth::Builder do
  provider :canvas, "d502eec9-2755-4c19-86b5-cebf38a5614a", "secret"
end
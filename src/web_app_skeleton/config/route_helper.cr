# This is used when generating URLs for your application
Lucky::RouteHelper.configure do
  if Lucky::Env.production?
    # Example: https://my_app.com
    settings.domain = ENV.fetch("APP_DOMAIN")
  else
    # Set domain to the default host/port in development
    settings.domain = "http://localhost:3001"
  end
end

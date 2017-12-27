# This is used when generating URLs for your application
Lucky::RouteHelper.configure do
  if Lucky::Env.production?
    # Example: https://my_app.com
    settings.domain = ENV.fetch("APP_DOMAIN")
  else
    settings.domain = "http:://localhost:5000"
  end
end

require "mime"


Lucky::RouteHandler.configure do |settings|
  # Uncomment this setting to add your own custom mime types.
  # [Learn more on mime types](https://crystal-lang.org/api/latest/MIME.html)
  #
  # Set the key as the file extension you want to register,
  # and the value of the `Content-Type` request header.
  #
  # settings.mime_extensions = {
  #   ".pptx" => "application/vnd.openxmlformats-officedocument.presentationml.pre"
  # }
end

# Register all custom mime extensions
Lucky::RouteHandler.settings.mime_extensions.each do |ext, type|
  MIME.register(ext, type)
end

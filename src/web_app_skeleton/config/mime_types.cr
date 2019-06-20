require "mime"


Lucky::RouteHandler.configure do |settings|
  # Add in this setting to set your own custom mime types
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

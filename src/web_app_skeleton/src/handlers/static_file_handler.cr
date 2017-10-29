require "http"

class StaticFileHandler < HTTP::StaticFileHandler
  @compress_handler : HTTP::Handler = HTTP::CompressHandler.new

  private def should_compress?(context)
    (context.response.headers["Content-Length"]? || 0).to_i >= 1400 # assuming an MTU of 1500 bytes, compress responses that span multiple packets
  end

  def call(context)
    super(context)
    @compress_handler.call(context) if should_compress? context
  end

  private def mime_type(path)
    case File.extname(path)
    when ".txt"          then "text/plain"
    when ".htm", ".html" then "text/html"
    when ".css"          then "text/css"
    when ".js"           then "application/javascript"
    when ".svg"          then "image/svg+xml"
    when ".svgz"         then "image/svg+xml"
    else                      "application/octet-stream"
    end
  end
end

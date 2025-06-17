class ApiClient < Lucky::BaseHTTPClient
  app AppServer.new

  def initialize
    super
    headers("Content-Type": "application/json")
  end
end

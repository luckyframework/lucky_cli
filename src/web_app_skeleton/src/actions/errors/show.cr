class Errors::Show < Lucky::ErrorAction
  def handle_error(error : JSON::ParseException)
    if json?
      message = "There was a problem parsing the JSON." \
                " Please check that it is formed correctly"
      json Errors::ShowSerializer.new(message), status: 400
    else
      render_error_page status: 500
    end
  end

  def handle_error(error : Exception)
    error.inspect_with_backtrace(STDERR)

    if json?
      message = "An unexpected error occurred"
      json Errors::ShowSerializer.new(message), status: 500
    else
      render_error_page status: 500
    end
  end

  private def render_error_page(status : Int32, title : String = "We're sorry. Something went wrong.")
    render Errors::ShowPage, status: status, title: title
  end
end

class Errors::Show < LuckyWeb::ErrorAction
  def handle_error(error : Exception)
    head status: 500
  end
end

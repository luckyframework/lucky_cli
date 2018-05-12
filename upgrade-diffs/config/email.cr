BaseEmail.configure do
  if Lucky::Env.production?
    send_grid_key = ENV.fetch("SEND_GRID_KEY")
    settings.adapter = Carbon::SendGridAdapter.new(api_key: send_grid_key)
  else
    settings.adapter = Carbon::DevAdapter.new
  end
end

require "jwt"

module Auth::Api::ActionHelpers
  def sign_in(user : Authentic::PasswordAuthenticatable)
    context.response.headers.add "Authorization", user.generate_token
  end

  def token
    context.request.headers["Authorization"]?
  end

  def current_user?
    token.try do |value|
      user_from_token(value)
    end
  rescue JWT::DecodeError | JWT::ExpiredSignatureError
    nil
  end

  def user_from_token(token : String)
    payload, _header = JWT.decode(token, Lucky::Server.settings.secret_key_base, "HS256")
    id = payload["sub"].to_s.to_i
    find_current_user(id)
  end
end

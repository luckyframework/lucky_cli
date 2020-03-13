class Api::LogIns::Create < ApiAction
  include Api::Auth::SkipRequireAuthToken

  route do
    LogInUser.new(params).submit do |operation, user|
      if user
        json({token: UserToken.generate(user)})
      else
        raise Avram::InvalidOperationError.new(operation)
      end
    end
  end
end

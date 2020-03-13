module Auth::PasswordResets::Base
  macro included
    include Auth::RedirectLoggedInUsers
    include Auth::PasswordResets::FindUser
    include Auth::PasswordResets::RequireToken
  end
end

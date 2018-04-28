class User < BaseModel
  include Carbon::Emailable

  table :users do
    column email : String
    column encrypted_password : String
  end

  def carbon_address
    Carbon::Address.new(email)
  end
end

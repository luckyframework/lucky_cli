class CreateUsers::V00000000000001 < LuckyRecord::Migrator::Migration::V1
  def migrate
    create :users do
      add email : String, unique: true
      add encrypted_password : String
    end
  end

  def rollback
    drop :users
  end
end

class BaseAuthenticationSrcTemplate
  def render(path : Path)
    LuckyTemplate.write!(path, template_folder)
  end

  def template_folder
    LuckyTemplate.create_folder do |root_dir|
      root_dir.add_file("config/authentic.cr") do |io|
        ECR.embed("#{__DIR__}/../base_authentication_app_skeleton/config/authentic.cr.ecr", io)
      end
      root_dir.add_folder("db/migrations") do |migrations_dir|
        migrations_dir.add_file(".keep")
        migrations_dir.add_file("00000000000001_create_users.cr") do |io|
          ECR.embed("#{__DIR__}/../base_authentication_app_skeleton/db/migrations/00000000000001_create_users.cr.ecr", io)
        end
      end
      root_dir.add_folder("spec/support") do |support_dir|
        support_dir.add_file(".keep")
        support_dir.add_file("factories/user_factory.cr") do |io|
          ECR.embed("#{__DIR__}/../base_authentication_app_skeleton/spec/support/factories/user_factory.cr.ecr", io)
        end
      end
      root_dir.insert_folder("src", src_folder)
    end
  end

  def src_folder
    LuckyTemplate.create_folder do |src_dir|
      src_dir.add_file("models/user.cr") do |io|
        ECR.embed("#{__DIR__}/../base_authentication_app_skeleton/src/models/user.cr.ecr", io)
      end
      src_dir.add_file("queries/user_query.cr") do |io|
        ECR.embed("#{__DIR__}/../base_authentication_app_skeleton/src/queries/user_query.cr.ecr", io)
      end
      src_dir.add_folder("operations") do |ops_dir|
        ops_dir.add_file(".keep")
        # ...
        ops_dir.add_folder("mixins") do |mixins_dir|
          mixins_dir.add_file(".keep")
          # ...
        end
      end
    end
  end
end

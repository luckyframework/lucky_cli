class ApiAuthenticationTemplate
  def render(path : Path)
    LuckyTemplate.write!(path, template_folder)
  end

  def template_folder
    LuckyTemplate.create_folder do |root_dir|
      root_dir.add_file(Path["spec/requests/api/me/show_spec.cr"]) do |io|
        ECR.embed("#{__DIR__}/../api_authentication_app_skeleton/spec/requests/api/me/show_spec.cr.ecr", io)
      end
      root_dir.add_file(Path["spec/requests/api/sign_ins/create_spec.cr"]) do |io|
        ECR.embed("#{__DIR__}/../api_authentication_app_skeleton/spec/requests/api/sign_ins/create_spec.cr.ecr", io)
      end
      root_dir.add_file(Path["spec/requests/api/sign_ups/create_spec.cr"]) do |io|
        ECR.embed("#{__DIR__}/../api_authentication_app_skeleton/spec/requests/api/sign_ups/create_spec.cr.ecr", io)
      end

      root_dir.add_file(Path["src/actions/api/me/show.cr"]) do |io|
        ECR.embed("#{__DIR__}/../api_authentication_app_skeleton/src/actions/api/me/show.cr.ecr", io)
      end
      root_dir.add_file(Path["src/actions/api/sign_ins/create.cr"]) do |io|
        ECR.embed("#{__DIR__}/../api_authentication_app_skeleton/src/actions/api/sign_ins/create.cr.ecr", io)
      end
      root_dir.add_file(Path["src/actions/api/sign_ups/create.cr"]) do |io|
        ECR.embed("#{__DIR__}/../api_authentication_app_skeleton/src/actions/api/sign_ups/create.cr.ecr", io)
      end
      root_dir.add_folder(Path["src/actions/mixins"]) do |mixins_dir|
        mixins_dir.add_file(Path["api/auth/helpers.cr"]) do |io|
          ECR.embed("#{__DIR__}/../api_authentication_app_skeleton/src/actions/mixins/api/auth/helpers.cr.ecr", io)
        end
        mixins_dir.add_file(Path["api/auth/require_auth_token.cr"]) do |io|
          ECR.embed("#{__DIR__}/../api_authentication_app_skeleton/src/actions/mixins/api/auth/require_auth_token.cr.ecr", io)
        end
        mixins_dir.add_file(Path["api/auth/skip_require_auth_token.cr"]) do |io|
          ECR.embed("#{__DIR__}/../api_authentication_app_skeleton/src/actions/mixins/api/auth/skip_require_auth_token.cr.ecr", io)
        end
      end
      root_dir.add_file(Path["src/models/user_token.cr"]) do |io|
        ECR.embed("#{__DIR__}/../api_authentication_app_skeleton/src/models/user_token.cr.ecr", io)
      end
      root_dir.add_file(Path["src/serializers/user_serializer.cr"]) do |io|
        ECR.embed("#{__DIR__}/../api_authentication_app_skeleton/src/serializers/user_serializer.cr.ecr", io)
      end
    end
  end
end

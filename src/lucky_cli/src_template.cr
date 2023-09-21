require "random/secure"

class SrcTemplate
  getter project_name
  getter? api_only, generate_auth, with_sec_tester
  getter crystal_project_name : String
  property(secret_key_base) { Random::Secure.base64(32) }
  property(crystal_version) { Crystal::VERSION }
  property(lucky_cli_version) { LuckyCli::VERSION }

  def initialize(
    @project_name : String,
    @generate_auth : Bool,
    @api_only : Bool,
    @with_sec_tester : Bool
  )
    @crystal_project_name = @project_name.gsub("-", "_")
  end

  def proxied_through_browsersync?
    browser?
  end

  private def browser?
    !api_only?
  end

  def render(path : Path)
    LuckyTemplate.write!(path, template_folder)
  end

  def template_folder
    LuckyTemplate.create_folder do |root_dir|
      root_dir.add_file(".crystal-version") do |io|
        ECR.embed("#{__DIR__}/../web_app_skeleton/.crystal-version.ecr", io)
      end
      root_dir.add_file(".env") do |io|
        ECR.embed("#{__DIR__}/../web_app_skeleton/.env.ecr", io)
      end
      root_dir.add_file("docker-compose.yml") do |io|
        ECR.embed("#{__DIR__}/../web_app_skeleton/docker-compose.yml.ecr", io)
      end
      root_dir.add_file("Procfile") do |io|
        ECR.embed("#{__DIR__}/../web_app_skeleton/Procfile.ecr", io)
      end
      root_dir.add_file("Procfile.dev") do |io|
        ECR.embed("#{__DIR__}/../web_app_skeleton/Procfile.dev.ecr", io)
      end
      root_dir.add_file("README.md") do |io|
        ECR.embed("#{__DIR__}/../web_app_skeleton/README.md.ecr", io)
      end
      root_dir.add_file("tasks.cr") do |io|
        ECR.embed("#{__DIR__}/../web_app_skeleton/tasks.cr.ecr", io)
      end
      root_dir.add_folder(".github") do |dot_gh_dir|
        dot_gh_dir.add_folder("workflows") do |workflows_dir|
          workflows_dir.add_file("ci.yml") do |io|
            ECR.embed("#{__DIR__}/../web_app_skeleton/.github/workflows/ci.yml.ecr", io)
          end
        end
      end
      root_dir.add_folder("config") do |config_dir|
        config_dir.add_file("application.cr") do |io|
          ECR.embed("#{__DIR__}/../web_app_skeleton/config/application.cr.ecr", io)
        end
        config_dir.add_file("colors.cr") do |io|
          ECR.embed("#{__DIR__}/../web_app_skeleton/config/colors.cr.ecr", io)
        end
        config_dir.add_file("cookies.cr") do |io|
          ECR.embed("#{__DIR__}/../web_app_skeleton/config/cookies.cr.ecr", io)
        end
        config_dir.add_file("database.cr") do |io|
          ECR.embed("#{__DIR__}/../web_app_skeleton/config/database.cr.ecr", io)
        end
        config_dir.add_file("email.cr") do |io|
          ECR.embed("#{__DIR__}/../web_app_skeleton/config/email.cr.ecr", io)
        end
        config_dir.add_file("env.cr") do |io|
          ECR.embed("#{__DIR__}/../web_app_skeleton/config/env.cr.ecr", io)
        end
        config_dir.add_file("error_handler.cr") do |io|
          ECR.embed("#{__DIR__}/../web_app_skeleton/config/error_handler.cr.ecr", io)
        end
        config_dir.add_file("log.cr") do |io|
          ECR.embed("#{__DIR__}/../web_app_skeleton/config/log.cr.ecr", io)
        end
        config_dir.add_file("route_helper.cr") do |io|
          ECR.embed("#{__DIR__}/../web_app_skeleton/config/route_helper.cr.ecr", io)
        end
        config_dir.add_file("server.cr") do |io|
          ECR.embed("#{__DIR__}/../web_app_skeleton/config/server.cr.ecr", io)
        end
        config_dir.add_file("watch.yml") do |io|
          ECR.embed("#{__DIR__}/../web_app_skeleton/config/watch.yml.ecr", io)
        end
      end
      root_dir.add_folder("db") do |db_dir|
        db_dir.add_file("migrations/.keep")
      end
      root_dir.add_folder("docker") do |docker_dir|
        docker_dir.add_file("dev_entrypoint.sh", 0o755) do |io|
          ECR.embed("#{__DIR__}/../web_app_skeleton/docker/dev_entrypoint.sh.ecr", io)
        end
        docker_dir.add_file("development.dockerfile") do |io|
          ECR.embed("#{__DIR__}/../web_app_skeleton/docker/development.dockerfile.ecr", io)
        end
        docker_dir.add_file("wait-for-it.sh", 0o755) do |io|
          ECR.embed("#{__DIR__}/../web_app_skeleton/docker/wait-for-it.sh.ecr", io)
        end
      end
      root_dir.add_folder("script") do |script_dir|
        script_dir.add_file("setup", 0o755) do |io|
          ECR.embed("#{__DIR__}/../web_app_skeleton/script/setup.ecr", io)
        end
        script_dir.add_file("system_check", 0o755) do |io|
          ECR.embed("#{__DIR__}/../web_app_skeleton/script/system_check.ecr", io)
        end
        script_dir.add_folder("helpers") do |helpers_dir|
          helpers_dir.add_file("function_helpers") do |io|
            ECR.embed("#{__DIR__}/../web_app_skeleton/script/helpers/function_helpers.ecr", io)
          end
          helpers_dir.add_file("text_helpers") do |io|
            ECR.embed("#{__DIR__}/../web_app_skeleton/script/helpers/text_helpers.ecr", io)
          end
        end
      end
      root_dir.insert_folder("spec", spec_folder)
      root_dir.insert_folder("src", src_folder)
      root_dir.insert_folder("tasks", tasks_folder)
    end
  end

  private def spec_folder
    LuckyTemplate.create_folder do |spec_dir|
      spec_dir.add_file("spec_helper.cr") do |io|
        ECR.embed("#{__DIR__}/../web_app_skeleton/spec/spec_helper.cr.ecr", io)
      end
      spec_dir.add_folder("setup") do |setup_dir|
        setup_dir.add_file("clean_database.cr") do |io|
          ECR.embed("#{__DIR__}/../web_app_skeleton/spec/setup/clean_database.cr.ecr", io)
        end
        setup_dir.add_file("reset_emails.cr") do |io|
          ECR.embed("#{__DIR__}/../web_app_skeleton/spec/setup/reset_emails.cr.ecr", io)
        end
        setup_dir.add_file("setup_database.cr") do |io|
          ECR.embed("#{__DIR__}/../web_app_skeleton/spec/setup/setup_database.cr.ecr", io)
        end
        setup_dir.add_file("start_app_server.cr") do |io|
          ECR.embed("#{__DIR__}/../web_app_skeleton/spec/setup/start_app_server.cr.ecr", io)
        end
      end
      spec_dir.add_folder("support") do |support_dir|
        support_dir.add_file(".keep")
        support_dir.add_file("api_client.cr") do |io|
          ECR.embed("#{__DIR__}/../web_app_skeleton/spec/support/api_client.cr.ecr", io)
        end
        support_dir.add_file("factories/.keep")
      end
    end
  end

  private def src_folder
    LuckyTemplate.create_folder do |src_dir|
      src_dir.add_file("app.cr") do |io|
        ECR.embed("#{__DIR__}/../web_app_skeleton/src/app.cr.ecr", io)
      end
      src_dir.add_file("app_database.cr") do |io|
        ECR.embed("#{__DIR__}/../web_app_skeleton/src/app_database.cr.ecr", io)
      end
      src_dir.add_file("app_server.cr") do |io|
        ECR.embed("#{__DIR__}/../web_app_skeleton/src/app_server.cr.ecr", io)
      end
      src_dir.add_file("shards.cr") do |io|
        ECR.embed("#{__DIR__}/../web_app_skeleton/src/shards.cr.ecr", io)
      end
      src_dir.add_file("start_server.cr") do |io|
        ECR.embed("#{__DIR__}/../web_app_skeleton/src/start_server.cr.ecr", io)
      end
      src_dir.add_file("#{crystal_project_name}.cr") do |io|
        ECR.embed("#{__DIR__}/../web_app_skeleton/src/project_name.cr.ecr", io)
      end
      src_dir.add_folder("actions") do |actions_dir|
        actions_dir.add_file("api_action.cr") do |io|
          ECR.embed("#{__DIR__}/../web_app_skeleton/src/actions/api_action.cr.ecr", io)
        end
        actions_dir.add_folder("errors") do |errors_dir|
          errors_dir.add_file("show.cr") do |io|
            ECR.embed("#{__DIR__}/../web_app_skeleton/src/actions/errors/show.cr.ecr", io)
          end
        end
        actions_dir.add_folder("home") do |home_dir|
          home_dir.add_file("index.cr") do |io|
            ECR.embed("#{__DIR__}/../web_app_skeleton/src/actions/home/index.cr.ecr", io)
          end
        end
        actions_dir.add_file("mixins/.keep")
      end
      src_dir.add_folder("emails") do |emails_dir|
        emails_dir.add_file("base_email.cr") do |io|
          ECR.embed("#{__DIR__}/../web_app_skeleton/src/emails/base_email.cr.ecr", io)
        end
      end
      src_dir.add_folder("models") do |models_dir|
        models_dir.add_file("base_model.cr") do |io|
          ECR.embed("#{__DIR__}/../web_app_skeleton/src/models/base_model.cr.ecr", io)
        end
        models_dir.add_file("mixins/.keep")
      end
      src_dir.add_folder("operations") do |ops_dir|
        ops_dir.add_file(".keep")
        ops_dir.add_file("mixins/.keep")
      end
      src_dir.add_folder("queries") do |queries_dir|
        queries_dir.add_file(".keep")
        queries_dir.add_file("mixins/.keep")
      end
      src_dir.add_folder("serializers") do |serializers_dir|
        serializers_dir.add_file(".keep")
        serializers_dir.add_file("base_serializer.cr") do |io|
          ECR.embed("#{__DIR__}/../web_app_skeleton/src/serializers/base_serializer.cr.ecr", io)
        end
        serializers_dir.add_file("error_serializer.cr") do |io|
          ECR.embed("#{__DIR__}/../web_app_skeleton/src/serializers/error_serializer.cr.ecr", io)
        end
      end
    end
  end

  private def tasks_folder
    LuckyTemplate.create_folder do |tasks_dir|
      tasks_dir.add_file(".keep")
      tasks_dir.add_folder("db/seed") do |seed_dir|
        seed_dir.add_file("required_data.cr") do |io|
          ECR.embed("#{__DIR__}/../web_app_skeleton/tasks/db/seed/required_data.cr.ecr", io)
        end
        seed_dir.add_file("sample_data.cr") do |io|
          ECR.embed("#{__DIR__}/../web_app_skeleton/tasks/db/seed/sample_data.cr.ecr", io)
        end
      end
    end
  end
end

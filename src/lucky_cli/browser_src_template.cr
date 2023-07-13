require "random/secure"

class BrowserSrcTemplate
  getter? generate_auth

  def initialize(@generate_auth : Bool)
  end

  def render(path : Path)
    LuckyTemplate.write!(path, template_folder)
  end

  def template_folder
    LuckyTemplate.create_folder do |root_dir|
      root_dir.add_file("bs-config.js") do |io|
        ECR.embed("#{__DIR__}/../browser_app_skeleton/bs-config.js.ecr", io)
      end
      root_dir.add_file("package.json") do |io|
        ECR.embed("#{__DIR__}/../browser_app_skeleton/package.json.ecr", io)
      end
      root_dir.add_file("webpack.mix.js") do |io|
        ECR.embed("#{__DIR__}/../browser_app_skeleton/webpack.mix.js.ecr", io)
      end
      root_dir.add_folder("config") do |config_dir|
        config_dir.add_file("html_page.cr") do |io|
          ECR.embed("#{__DIR__}/../browser_app_skeleton/config/html_page.cr.ecr", io)
        end
      end
      root_dir.add_folder("db") do |db_dir|
        db_dir.add_file("migrations/.keep")
      end
      root_dir.add_folder("public") do |public_dir|
        public_dir.add_file("favicon.ico") do |io|
          ECR.embed("#{__DIR__}/../browser_app_skeleton/public/favicon.ico.ecr", io)
        end
        public_dir.add_file("mix-manifest.json") do |io|
          ECR.embed("#{__DIR__}/../browser_app_skeleton/public/mix-manifest.json.ecr", io)
        end
        public_dir.add_file("robots.txt") do |io|
          ECR.embed("#{__DIR__}/../browser_app_skeleton/public/robots.txt.ecr", io)
        end
        public_dir.add_file("assets/images/.keep")
      end
      root_dir.insert_folder("spec", spec_folder)
      root_dir.insert_folder("src", src_folder)
    end
  end

  private def spec_folder
    LuckyTemplate.create_folder do |spec_dir|
      spec_dir.add_file("flows/.keep")
      spec_dir.add_folder("setup") do |setup_dir|
        setup_dir.add_file(".keep")
        setup_dir.add_file("configure_lucky_flow.cr") do |io|
          ECR.embed("#{__DIR__}/../browser_app_skeleton/spec/setup/configure_lucky_flow.cr.ecr", io)
        end
      end
      spec_dir.add_folder("support") do |support_dir|
        support_dir.add_file(".keep")
        support_dir.add_file("factories/.keep")
        support_dir.add_file("flows/base_flow.cr") do |io|
          ECR.embed("#{__DIR__}/../browser_app_skeleton/spec/support/flows/base_flow.cr.ecr", io)
        end
      end
    end
  end

  private def src_folder
    LuckyTemplate.create_folder do |src_dir|
      src_dir.add_file("actions/browser_action.cr") do |io|
        ECR.embed("#{__DIR__}/../browser_app_skeleton/src/actions/browser_action.cr.ecr", io)
      end
      src_dir.add_folder("components") do |components_dir|
        components_dir.add_file(".keep")
        components_dir.add_file("base_component.cr") do |io|
          ECR.embed("#{__DIR__}/../browser_app_skeleton/src/components/base_component.cr.ecr", io)
        end
        components_dir.add_folder("shared") do |shared_dir|
          shared_dir.add_file("field.cr") do |io|
            ECR.embed("#{__DIR__}/../browser_app_skeleton/src/components/shared/field.cr.ecr", io)
          end
          shared_dir.add_file("field_errors.cr") do |io|
            ECR.embed("#{__DIR__}/../browser_app_skeleton/src/components/shared/field_errors.cr.ecr", io)
          end
          shared_dir.add_file("flash_messages.cr") do |io|
            ECR.embed("#{__DIR__}/../browser_app_skeleton/src/components/shared/flash_messages.cr.ecr", io)
          end
          shared_dir.add_file("layout_head.cr") do |io|
            ECR.embed("#{__DIR__}/../browser_app_skeleton/src/components/shared/layout_head.cr.ecr", io)
          end
        end
      end
      src_dir.add_folder("css") do |css_dir|
        css_dir.add_file("app.scss") do |io|
          ECR.embed("#{__DIR__}/../browser_app_skeleton/src/css/app.scss.ecr", io)
        end
        css_dir.add_folder("components/.keep")
        css_dir.add_folder("mixins/.keep")
        css_dir.add_folder("variables/.keep")
      end
      src_dir.add_file("emails/.keep")
      src_dir.add_file("js/app.js") do |io|
        ECR.embed("#{__DIR__}/../browser_app_skeleton/src/js/app.js.ecr", io)
      end
      src_dir.add_folder("models") do |models_dir|
        models_dir.add_file("mixins/.keep")
      end
      src_dir.add_folder("operations") do |ops_dir|
        ops_dir.add_file(".keep")
        ops_dir.add_file("mixins/.keep")
      end
      src_dir.add_folder("pages") do |pages_dir|
        pages_dir.add_file("main_layout.cr") do |io|
          ECR.embed("#{__DIR__}/../browser_app_skeleton/src/pages/main_layout.cr.ecr", io)
        end
        pages_dir.add_file("errors/show_page.cr") do |io|
          ECR.embed("#{__DIR__}/../browser_app_skeleton/src/pages/show_page.cr.ecr", io)
        end
      end
    end
  end
end

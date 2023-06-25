class BrowserAuthenticationSrcTemplate
  def render(path : Path)
    LuckyTemplate.write!(path, template_folder)
  end

  def template_folder
    LuckyTemplate.create_folder do |root_dir|
      root_dir.add_folder("spec") do |spec_dir|
        spec_dir.add_folder("flows") do |flows_dir|
          flows_dir.add_file("authentication_spec.cr") do |io|
            ECR.embed("#{__DIR__}/../browser_authentication_app_skeleton/spec/flows/authentication_spec.cr.ecr", io)
          end
          flows_dir.add_file("reset_password_spec.cr") do |io|
            ECR.embed("#{__DIR__}/../browser_authentication_app_skeleton/spec/flows/reset_password_spec.cr.ecr", io)
          end
        end
        spec_dir.add_folder("support") do |support_dir|
          support_dir.add_file(".keep")
          support_dir.add_folder("flows") do |flows_dir|
            flows_dir.add_file("authentication_flow.cr") do |io|
              ECR.embed("#{__DIR__}/../browser_authentication_app_skeleton/spec/support/flows/authentication_flow.cr.ecr", io)
            end
            flows_dir.add_file("reset_password_flow.cr") do |io|
              ECR.embed("#{__DIR__}/../browser_authentication_app_skeleton/spec/support/flows/reset_password_flow.cr.ecr", io)
            end
          end
        end
      end
      root_dir.add_folder("src") do |src_dir|
        src_dir.insert_folder("actions", actions_folder)
        src_dir.insert_folder("emails", emails_folder)
        src_dir.insert_folder("pages", pages_folder)
      end
    end
  end

  private def actions_folder
    LuckyTemplate.create_folder do |actions_dir|
      actions_dir.add_folder("me") do |me_dir|
        me_dir.add_file("show.cr") do |io|
          ECR.embed("#{__DIR__}/../browser_authentication_app_skeleton/src/actions/me/show.cr.ecr", io)
        end
      end
      actions_dir.add_folder("mixins") do |mixins_dir|
        mixins_dir.add_file(".keep")
        mixins_dir.add_folder("auth") do |auth_dir|
          auth_dir.add_file("allow_guests.cr") do |io|
            ECR.embed("#{__DIR__}/../browser_authentication_app_skeleton/src/actions/mixins/auth/allow_guests.cr.ecr", io)
          end
          auth_dir.add_file("redirect_signed_in_users.cr") do |io|
            ECR.embed("#{__DIR__}/../browser_authentication_app_skeleton/src/actions/mixins/auth/redirect_signed_in_users.cr.ecr", io)
          end
          auth_dir.add_file("require_sign_in.cr") do |io|
            ECR.embed("#{__DIR__}/../browser_authentication_app_skeleton/src/actions/mixins/auth/require_sign_in.cr.ecr", io)
          end
          auth_dir.add_file("test_backdoor.cr") do |io|
            ECR.embed("#{__DIR__}/../browser_authentication_app_skeleton/src/actions/mixins/auth/test_backdoor.cr.ecr", io)
          end
          auth_dir.add_folder("password_resets") do |password_resets_dir|
            password_resets_dir.add_file("base.cr") do |io|
              ECR.embed("#{__DIR__}/../browser_authentication_app_skeleton/src/actions/mixins/auth/password_resets/base.cr.ecr", io)
            end
            password_resets_dir.add_file("find_user.cr") do |io|
              ECR.embed("#{__DIR__}/../browser_authentication_app_skeleton/src/actions/mixins/auth/password_resets/find_user.cr.ecr", io)
            end
            password_resets_dir.add_file("require_token.cr") do |io|
              ECR.embed("#{__DIR__}/../browser_authentication_app_skeleton/src/actions/mixins/auth/password_resets/require_token.cr.ecr", io)
            end
            password_resets_dir.add_file("token_from_session.cr") do |io|
              ECR.embed("#{__DIR__}/../browser_authentication_app_skeleton/src/actions/mixins/auth/password_resets/token_from_session.cr.ecr", io)
            end
          end
        end
      end
      actions_dir.add_folder("password_reset_requests") do |password_reset_requests_dir|
        password_reset_requests_dir.add_file("create.cr") do |io|
          ECR.embed("#{__DIR__}/../browser_authentication_app_skeleton/src/actions/password_reset_requests/create.cr.ecr", io)
        end
        password_reset_requests_dir.add_file("new.cr") do |io|
          ECR.embed("#{__DIR__}/../browser_authentication_app_skeleton/src/actions/password_reset_requests/new.cr.ecr", io)
        end
      end
      actions_dir.add_folder("password_resets") do |password_resets_dir|
        password_resets_dir.add_file("create.cr") do |io|
          ECR.embed("#{__DIR__}/../browser_authentication_app_skeleton/src/actions/password_resets/create.cr.ecr", io)
        end
        password_resets_dir.add_file("edit.cr") do |io|
          ECR.embed("#{__DIR__}/../browser_authentication_app_skeleton/src/actions/password_resets/edit.cr.ecr", io)
        end
        password_resets_dir.add_file("new.cr") do |io|
          ECR.embed("#{__DIR__}/../browser_authentication_app_skeleton/src/actions/password_resets/new.cr.ecr", io)
        end
      end
      actions_dir.add_folder("sign_ins") do |sign_ins_dir|
        sign_ins_dir.add_file("create.cr") do |io|
          ECR.embed("#{__DIR__}/../browser_authentication_app_skeleton/src/actions/sign_ins/create.cr.ecr", io)
        end
        sign_ins_dir.add_file("delete.cr") do |io|
          ECR.embed("#{__DIR__}/../browser_authentication_app_skeleton/src/actions/sign_ins/delete.cr.ecr", io)
        end
        sign_ins_dir.add_file("new.cr") do |io|
          ECR.embed("#{__DIR__}/../browser_authentication_app_skeleton/src/actions/sign_ins/new.cr.ecr", io)
        end
      end
      actions_dir.add_folder("sign_ups") do |sign_ups_dir|
        sign_ups_dir.add_file("create.cr") do |io|
          ECR.embed("#{__DIR__}/../browser_authentication_app_skeleton/src/actions/sign_ups/create.cr.ecr", io)
        end
        sign_ups_dir.add_file("new.cr") do |io|
          ECR.embed("#{__DIR__}/../browser_authentication_app_skeleton/src/actions/sign_ups/new.cr.ecr", io)
        end
      end
    end
  end

  private def emails_folder
    LuckyTemplate.create_folder do |emails_dir|
      emails_dir.add_file("password_reset_request_email.cr") do |io|
        ECR.embed("#{__DIR__}/../browser_authentication_app_skeleton/src/emails/password_reset_request_email.cr.ecr", io)
      end
      emails_dir.add_folder("templates/password_reset_request_email") do |email_templates_dir|
        email_templates_dir.add_file("html.ecr") do |io|
          ECR.embed("#{__DIR__}/../browser_authentication_app_skeleton/src/emails/templates/password_reset_request_email/html.ecr.ecr", io)
        end
        email_templates_dir.add_file("text.ecr") do |io|
          ECR.embed("#{__DIR__}/../browser_authentication_app_skeleton/src/emails/templates/password_reset_request_email/text.ecr.ecr", io)
        end
      end
    end
  end

  private def pages_folder
    LuckyTemplate.create_folder do |pages_dir|
      pages_dir.add_folder("me") do |me_dir|
        me_dir.add_file("show_page.cr") do |io|
          ECR.embed("#{__DIR__}/../browser_authentication_app_skeleton/src/pages/me/show_page.cr.ecr", io)
        end
      end
      pages_dir.add_folder("password_reset_requests") do |password_reset_requests_dir|
        password_reset_requests_dir.add_file("new_page.cr") do |io|
          ECR.embed("#{__DIR__}/../browser_authentication_app_skeleton/src/pages/password_reset_requests/new_page.cr.ecr", io)
        end
      end
      pages_dir.add_folder("password_resets") do |password_resets_dir|
        password_resets_dir.add_file("new_page.cr") do |io|
          ECR.embed("#{__DIR__}/../browser_authentication_app_skeleton/src/pages/password_resets/new_page.cr.ecr", io)
        end
      end
      pages_dir.add_folder("sign_ins") do |sign_ins_dir|
        sign_ins_dir.add_file("new_page.cr") do |io|
          ECR.embed("#{__DIR__}/../browser_authentication_app_skeleton/src/pages/sign_ins/new_page.cr.ecr", io)
        end
      end
      pages_dir.add_folder("sign_ups") do |sign_ups_dir|
        sign_ups_dir.add_file("new_page.cr") do |io|
          ECR.embed("#{__DIR__}/../browser_authentication_app_skeleton/src/pages/sign_ups/new_page.cr.ecr", io)
        end
      end
      pages_dir.add_file("auth_layout.cr") do |io|
        ECR.embed("#{__DIR__}/../browser_authentication_app_skeleton/src/pages/auth_layout.cr.ecr", io)
      end
      pages_dir.add_file("main_layout.cr") do |io|
        ECR.embed("#{__DIR__}/../browser_authentication_app_skeleton/src/pages/main_layout.cr.ecr", io)
      end
    end
  end
end

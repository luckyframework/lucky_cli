require "../spec_helper"

{% if env("RUN_HEROKU_SPECS") == "1" %}
  include ShouldRunSuccessfully

  Spec.before_each do
    FileUtils.rm_rf("test-project")
  end

  describe "Initializing a new web project" do
    it "deploys a full web app successfully" do
      puts "Web app: Running Heroku deployment. This will take awhile...".colorize(:yellow)
      should_run_successfully "crystal src/lucky.cr init.custom test-project"
      app = generate_heroku_app_name

      deploy_to_heroku app, ->{
        should_run_successfully "yarn install"
        should_run_successfully "heroku buildpacks:add https://github.com/heroku/heroku-buildpack-nodejs"
      }

      # For some reason using HTTP::Client raises an End of file error
      # So instead we use `curl` to circumvent the issue
      `curl https://#{app}.herokuapp.com`.should contain("Welcome to Lucky")
    end

    it "deploys an API app successfully" do
      puts "API app: Running Heroku deployment. This will take awhile...".colorize(:yellow)
      should_run_successfully "crystal src/lucky.cr init.custom test-project -- --api"
      app = generate_heroku_app_name

      deploy_to_heroku app

      body = HTTP::Client.get("https://#{app}.herokuapp.com").body
      JSON.parse(body)["hello"].should eq("Hello World from Home::Index")
    end
  end

  private def generate_heroku_app_name
    app_name_base + "-" + Random::Secure.hex(4)
  end

  private def app_name_base
    ENV["HEROKU_APP_NAME"]? || "lucky-integration"
  end

  private def deploy_to_heroku(app_name, block = nil)
    Dir.cd("./test-project") do
      puts "Deploying #{app_name}"
      should_run_successfully "yarn install"
      io = IO::Memory.new
      should_run_successfully("heroku apps", output: io)
      io.to_s.split("\n").select(&.starts_with?(app_name_base)).each do |app|
        should_run_successfully "heroku apps:destroy #{app} --confirm #{app}"
      end
      should_run_successfully "heroku apps:create #{app_name}"
      should_run_successfully "heroku git:remote -a #{app_name}"
      block.call if block
      should_run_successfully "heroku buildpacks:add https://github.com/luckyframework/heroku-buildpack-crystal"
      should_run_successfully "heroku config:set LUCKY_ENV=production"
      should_run_successfully "heroku config:set SECRET_KEY_BASE=123abc"
      should_run_successfully "heroku config:set SEND_GRID_KEY=123abc"
      should_run_successfully "heroku config:set APP_DOMAIN=https://#{app_name}.herokuapp.com"
      should_run_successfully "heroku addons:create heroku-postgresql:hobby-dev"
      should_run_successfully "git add -A"
      should_run_successfully "git commit -m 'Init'"
      should_run_successfully "git push heroku master"
      wait_to_boot
    end
  end

  private def wait_to_boot
    sleep 20
  end
{% else %}
  {% puts "Skipping Heroku specs because RUN_HEROKU_SPECS was not set to 1" %}
{% end %}

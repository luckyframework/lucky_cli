# LuckyCli

A Crystal library for creating and running tasks

## Installing the CLI

1. Install [homebrew](http://brew.sh)
2. Run `brew tap luckyframework/lucky`
3. Run `brew install lucky`

Run `which lucky` from the command line to make sure it is installed.

**If you're generating a Lucky web project, [install the required dependencies](https://luckyframework.org/guides/installing.html#install-required-dependencies). Then run `lucky
init {project_name}`**

## Using LuckyCli in a non-Lucky web app

Add this to your application's `shard.yml`:

```yaml
dependencies:
  lucky_cli:
    github: luckyframework/lucky_cli
```

Create a file `tasks.cr` at the root of your project

```crystal
require "lucky_cli"

# Using `lucky` from the command line will do nothing if you forget this
LuckyCli::Runner.run
```

## Creating tasks

In `tasks.cr`

```crystal
class App::SendDailyNotifications < LuckyCli::Task
  # What this task does
  banner "Send notifications to users"

  # Name is inferred from class name ("app.send_daily_notifications")
  # It can be overriden if desired:
  # 
  #    name "app.send_daily_notifications"

  def call
    # Code that sends notifications to all your users
    puts "Sent daily notifications!"
  end
end

# LuckyCli::Runner.run is below this
```

This will create a task that can be run with `lucky app.send_daily_notifications`.
The name is inferred from the name of the class unless explicitly set with `name`.

You can see all available tasks by running `lucky --help`

## Contributing

1. Fork it ( https://github.com/luckyframework/lucky_cli/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [paulcsmith](https://github.com/paulcsmith) Paul Smith - creator, maintainer

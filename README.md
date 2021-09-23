# Lucky CLI

A Crystal library for creating and running tasks

## Installing the CLI by Homebrew

To install the Lucky CLI, read the guides for your Operating System [here](https://luckyframework.org/guides/getting-started/installing)

## Development

** Building the CLI **
1.  Install [crystal](https://github.com/crystal-lang/crystal)
2.  Clone the repo `git clone https://github.com/luckyframework/lucky_cli`
3.  Go to the repo directory `cd lucky_cli`
4.  Run `shards install`
5.  Run `crystal build src/lucky.cr -o /usr/local/bin/lucky`
    (instead of `/usr/local/bin/` destination you can choose any other directory that in `$PATH`)

Run `which lucky` from the command line to make sure it is installed.

**If you're generating a Lucky web project, [install the required dependencies](https://luckyframework.org/guides/getting-started/installing#install-required-dependencies). Then run `lucky init`**

## Documentation

[API (master)](https://luckyframework.github.io/lucky_cli/)

## Adding Custom Tasks

Want to add custom tasks?
Check out [LuckyTask](https://github.com/luckyframework/lucky_task) for getting started.

## Contributing

1.  Fork it ( https://github.com/luckyframework/lucky_cli/fork )
1.  Create your feature branch (git checkout -b my-new-feature)
1.  Commit your changes (git commit -am 'Add some feature')
1.  Push to the branch (git push origin my-new-feature)
1.  Check that specs on GitHub Actions CI pass
1.  Create a new Pull Request

## Testing Deployment to Heroku

Testing deployment to Heroku is skipped locally by default. The easiest way
to run the deployment tests is to push up a branch and open a PR. This will
run tests against Heroku to make sure deployment is working as expected.

If you want though, you can also test deployment locally:

1. Sign up for a Heroku account and install the CLI.
1. Run `heroku authorizations:create --description="Lucky CLI Integration Tests"`.
1. Grab the token from that command and put it in the generated `.env` file.
1. Change `RUN_HEROKU_SPECS` from `0` to `1` in the `.env` file.
1. Run `script/setup` to make sure all dependencies are installed.
1. Run `script/test` to test everything, or run `script/test specs/integration/deploy_to_heroku_spec.cr`

## Contributors

- [paulcsmith](https://github.com/paulcsmith) Paul Smith - creator, maintainer

# Lucky CLI

This is the CLI utility used for generating new [Lucky Framework](https://luckyframework.org) Web applications.

If you're looking for the Lucky core shard, you'll find that at https://github.com/luckyframework/lucky

## Installing the CLI

To install the Lucky CLI, read [Installing Lucky](https://luckyframework.org/guides/getting-started/installing) guides for your Operating System.

## Development

### Building the CLI

*NOTE:* this should be used for working on the CLI and submitting PRs.

1.  Install [Crystal](https://crystal-lang.org/install/) first.
2.  Clone the repo `git clone https://github.com/luckyframework/lucky_cli`
3.  Go to the repo directory `cd lucky_cli`
4.  Run the setup `./script/setup`
5.  Run `crystal build src/lucky.cr -o /usr/local/bin/lucky`
    (instead of `/usr/local/bin/` destination you can choose any other directory that in `$PATH`)

Run `which lucky` from the command line to make sure it is installed.

**If you're generating a Lucky web project, [install the required dependencies](https://luckyframework.org/guides/getting-started/installing#install-required-dependencies). Then run `lucky init`**

## API Documentation

[API (main)](https://luckyframework.github.io/lucky_cli/)

## Contributing

1.  Fork it ( https://github.com/luckyframework/lucky_cli/fork )
2.  Create your feature branch (git checkout -b my-new-feature)
3.  Commit your changes (git commit -am 'Add some feature')
4.  Push to the branch (git push origin my-new-feature)
5.  Check that specs on GitHub Actions CI pass
6.  Create a new Pull Request

## Testing Deployment to Heroku

Testing deployment to Heroku is skipped locally by default. The easiest way
to run the deployment tests is to push up a branch and open a PR. This will
run tests against Heroku to make sure deployment is working as expected.

If you want though, you can also test deployment locally:

1. Sign up for a Heroku account and install the CLI.
2. Run `heroku authorizations:create --description="Lucky CLI Integration Tests"`.
3. Grab the token from that command and put it in the generated `.env` file.
4. Change `RUN_HEROKU_SPECS` from `0` to `1` in the `.env` file.
5. Run `script/setup` to make sure all dependencies are installed.
6. Run `script/test` to test everything, or run `script/test specs/integration/deploy_to_heroku_spec.cr`

## Contributors

- [paulcsmith](https://github.com/paulcsmith) Paul Smith - creator, maintainer

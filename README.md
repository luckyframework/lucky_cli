# Lucky CLI

[![Lucky CLI Main CI](https://github.com/luckyframework/lucky_cli/actions/workflows/ci.yml/badge.svg)](https://github.com/luckyframework/lucky_cli/actions/workflows/ci.yml)
[![Lucky CLI Weekly CI](https://github.com/luckyframework/lucky_cli/actions/workflows/weekly.yml/badge.svg)](https://github.com/luckyframework/lucky_cli/actions/workflows/weekly.yml)

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
4.  Install dependencies `shards install`
5.  Run `crystal build -o /usr/local/bin/lucky src/lucky.cr`
    (instead of `/usr/local/bin/` destination you can choose any other directory that in `$PATH`)

Run `which lucky` from the command line to make sure it is installed.

**If you're generating a Lucky web project, [install the required dependencies](https://luckyframework.org/guides/getting-started/installing#install-required-dependencies). Then run `lucky init`**

## Contributing

1.  Fork it ( https://github.com/luckyframework/lucky_cli/fork )
2.  Create your feature branch (git checkout -b my-new-feature)
3.  Commit your changes (git commit -am 'Add some feature')
4.  Install [Earthly](https://earthly.dev/)
5.  Update fixtures with `earthly +update-snapshot`
6.  Push to the branch (git push origin my-new-feature)
7.  Check that specs on GitHub Actions CI pass `earthly +gh-action-e2e`
8.  Create a new Pull Request

## Contributors

[paulcsmith](https://github.com/paulcsmith) Paul Smith - Original Creator of Lucky

<a href="https://github.com/luckyframework/lucky_cli/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=luckyframework/lucky_cli" />
</a>

Made with [contrib.rocks](https://contrib.rocks).

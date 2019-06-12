# DeployLog

Get all Github pull requests for a specific timeframe, or search by title/branch name.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'deploy_log'
```

And then execute:

> $ bundle

Or install it yourself as:
> $ gem install deploy_log

## Usage

First, make sure your Github username and a [personal access token](https://github.com/settings/tokens) are setup as follows:

```bash
export GITHUB_USER="octocat"
export GITHUB_TOKEN="someRandomStringHere"
```

Search in any valid date range.

```bash
$ deploy_log my/repo --start=2019-06-11 --end=2019-06-12

# My PR title (https://github.com/my/repo/pull/1)
#  - Created by octocat
#  - Branch: my_branch
#  - Merged by octocat on 11/6/2019 @ 04:13:35pm
#  - Changes: https://github.com/my/repo/pull/1.diff
#
# ============================================================
# 1 PR(s) merged from 2019-06-11 00:00:00 -0600 to 2019-06-12 00:00:00 -0600
# ============================================================
```

Search by PR name.

```bash
$ deploy_log my/repo --title="My PR title"

# My PR title (https://github.com/my/repo/pull/1)
#  - Created by octocat
#  - Branch: my_branch
#  - Merged by octocat on 11/6/2019 @ 04:13:35pm
#  - Changes: https://github.com/my/repo/pull/1.diff
#
# ============================================================
# 1 PR(s) matched
# ============================================================
```

Find a PR by branch name.

```bash
$ deploy_log my/repo --branch="my_branch"

# My PR title (https://github.com/my/repo/pull/1)
#  - Created by octocat
#  - Branch: my_branch
#  - Merged by octocat on 11/6/2019 @ 04:13:35pm
#  - Changes: https://github.com/my/repo/pull/1.diff
#
# ============================================================
# 1 PR(s) matched
# ============================================================
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/deploy_log. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the DeployLog project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/deploy_log/blob/master/CODE_OF_CONDUCT.md).

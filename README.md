[![Circle CI](https://circleci.com/gh/Bernie-2016/CaucusCentralAPI.svg?style=svg)](https://circleci.com/gh/Bernie-2016/CaucusCentralAPI) 
[![Code Climate](https://codeclimate.com/github/Bernie-2016/CaucusCentralAPI/badges/gpa.svg)](https://codeclimate.com/github/Bernie-2016/CaucusCentralAPI) 
[![Test Coverage](https://codeclimate.com/github/Bernie-2016/CaucusCentralAPI/badges/coverage.svg)](https://codeclimate.com/github/Bernie-2016/CaucusCentralAPI/coverage) 

# CaucusCentralAPI

Caucus Central is an app to allow caucus precinct captains to quickly and easily calculate and share their candidate's viability with a campaign headquarters.

## Development

### Prerequisites

* git
* ruby 2.3.0 ([rvm](https://rvm.io/) recommended)
* [postgres](http://www.postgresql.org/) (`brew install postgres` on OSX)

### Setup

1. Clone the repository (`git clone git@github.com:Bernie-2016/CaucusCentralAPI.git`)
2. Install gem dependencies: `bundle install`
3. Create and migrate the database: `rake db:setup`
4. Create a `.env` file for the secret key, formatted as follows.
5. Run `rails s` and clone/setup the [client app](https://github.com/Bernie-2016/CaucusCentralFrontend)

```
SECRET_TOKEN=some_token
```

### Testing

* `bundle exec rspec` to run tests
* `bundle exec rubocop` for linting

## Contributing

1. Fork it ( https://github.com/Bernie-2016/CaucusCentralAPI/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## License

[AGPL](http://www.gnu.org/licenses/agpl-3.0.en.html)

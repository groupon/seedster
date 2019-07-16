# Seedster

Seedster is a way to work with real content in a development database, for a Rails application that uses Postgres.

> Why not use the built-in Rails seed mechanism?

We preferred a custom solution so that the development data was based on real production data, with referential integrity intact. What we settled on was exporting particular rows of data all driven from a specific user, to provide a meaningful set of related data that could periodically be refreshed with minimal effort over time.

> Briefly, how is it different from Rails' db seeds?

With Seedster, you write SQL queries for the tables you want data from. The queries can have a parameter like a user ID. A Rake task is provided to dump data from a production database, and a separate task is provided to load data locally on developers machines.

> This works with real user data?

Seedster uses content from a real user, so the recommendation is to use an employee user, test user, or something along those lines, so that the content being used for development is appropriate to share on a development team. Dump files can be viewed by all team members, to ensure they are based on an agreed upon user's data.

> What are the dependencies?

Seedster has developed for use with a Postgres database and depends on `psql`, `ssh`, `scp`, and `tar`.


## Process Overview

Requirements and expectations:

 * Local and remote database schema versions are in same. The development database is empty prior to load.
 * Use the provided Rake task to dump data from production. `rake seedster:dump` Individual dump files are consolidated into a single tar file.
 * Use the provided Rake task to download data file (`rake seedster:load`) to download, extract, and load the data
 * Use ENV variables to pass in dynamic data to SQL queries responsible for selecting data, for example supply `USER_ID` with a value on the command line, and add a parameter to your SQL query with syntax like this `%{}`, for example: `SELECT * FROM users WHERE id = '%{user_id}'`.


In order to dump the data for user ID 1, using a parameterized SQL query that expects a value for `user_id`:

```
prod_shell> USER_ID=1 rake seedster:dump
```

To download, extract, and load the data file:

```
dev_shell> rake seedster:load
```

## Table of Contents

* [Installation](#installation)
* [Initializer](#initializer)
* [Configuration Options](#configuration-options)
* [Seedster Development](#seedster-development)
 	* [Testing](#testing)
	* [Contributing](#contributing)
	* [Releasing a new version](#releasing-a-new-version)
	* [License](#contributing)
	* [Code of Conduct](#code-of-conduct)

### Installation

```ruby
gem 'seedster'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install seedster

### Initializer

An initializer is required to make Seedster work with your hosts, database, ssh config, and really drives everything that is unique to your application.

The gem provides an initializer. Run:

`rails generate seedster:initializer`

This will create a file `config/initializers/seedster.rb` where you can begin putting in values for your application. The configuration is both for DB credentials, SSH credentials, but also the configuration of the tables you wish to dump.

The initializer looks like this:

```ruby
Seedster.configure do |c|
  c.db_host = 'XXX'
  c.db_name = 'XXX'
  c.db_username = 'XXX'
  c.db_password = 'XXX'
  c.remote_host_path = '/var/company/www/app/current'
  c.query_params = {user_id: XXX}
  c.ssh_user = 'XXX'
  c.dump_host = 'XXX'
  c.tables = [
    {
      query: %{SELECT * FROM users WHERE id = '%{user_id}'},
      name: 'users'
    },
    {
      /* more tables here */
    }
  ]
end
```


### Configuration Options

##### `db_host`

Production database host. We use a read-only replica

##### `db_name`

Production database name

##### `db_username`

Production database username 

##### `db_password`

Production database password

##### `remote_host_path`

The path on the production host where the application is deployed. For example: `/var/company/www/app/current`.

##### `query_params`

To use a parameter like `user_id` in SQL queries, passing the value in via an environment variable like `USER_ID=1`, provide a mapping like this `{user_id: ENV['user_id']}`. Provide any additional key and value mappings you expect to be present when the query executes.

##### `ssh_user`

An SSH user that can connect (for purposes of downloading the file with `scp`) to the host where the production dump is.

##### `dump_host`

The host (a hostname) where the dump file is stored. We made this configurable to be able to dump data from production and staging.

##### `tables`

e.g. `tables = [ /* {name: '', query: '' } */ ]`
    
The tables option is where each query is stored. This is currently an array of hashes, with two items, `name` and `query`. `name` is the name of the database table, and `query` is the SQL query. We are dumping 10-15 tables worth of data for the same user, so that means we have 10-15 items specified here. This is where we would modify those queries over time to include or exclude more tables or fields of data.



## Seedster Development

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

### Testing

Run the test suite with `rake test`.

### Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/groupon/seedster. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

### Releasing a new version

1. Update the version in `seedster.gemspec`
2. `git commit seedster.gemspec` with the following message format:

        Version x.x.x

        Changelog:
        * Some new feature
        * Some new bug fix
3. `rake release`

### License

The gem is available as open source under the terms of the [APACHE LICENSE, VERSION 2.0](https://www.apache.org/licenses/LICENSE-2.0).

### Code of Conduct

Everyone interacting in the Seedster project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/groupon/seedster/blob/master/CODE_OF_CONDUCT.md).

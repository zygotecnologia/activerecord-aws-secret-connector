# ActiveRecord AWS Secret Connector
An adapter to make possibly to use active record and database.yml to connect to database using aws secrets manager

## Features

This adapter makes possible to store all database connection information on aws secrets manager, and even configure it to rotate the password from time to time,
and configures directly database.yml to connect to aws secret and easily use it to connect to the database.

This gem also uses rails can cache feature to store the database connection informations and avoid to connect and request those informations from ass secret every time. By default, it will expire the cache in 60 minutes.

## Installation

Add this line to gemfile

```ruby
gem "activerecord-aws-secret-connector"
```

And then run
```bash
bundle
```

After that, configure the database.yml, specifiyng the aws secret key that
```yaml
# config/database.yml

production:
  aws_secret: YOUR_AWS_SECRET_KAY_FOR_DATABASE_CONNECTION
```

This gem will connect to aws secret only for database config environments that has a `aws_secret` key on database.yml, working as default for other environments.

When `aws_secret` is present, it will ignore the keys `host`, `port`, `database`, `username` and `password`, even if they are passed on database.yml too. It will override the database.yml values with values from aws secret in that case.

## Options

### Cache expiration

By default, the gem will not use cache to store the database connection informations from aws secret. If you want to use cache and save some requests for aws secret, you need to set `cache_secret` key as true on database.yml, like below:

```yaml
production:
  aws_secret: YOUR_AWS_SECRET_KAY_FOR_DATABASE_CONNECTION
  cache_secret: true
```

When you set `cache_key` as true, the gem will use a default value for the cache key as DATABASE_SECRET_FOR_ENVIRONMENT and 60 minutes as expiration. Both attributes can be customized directly on database.yml too using `cache_key` and `cache_expires_in` keys. The value for `cache_expires_in` must be in minutes.

```yaml
production:
  aws_secret: YOUR_AWS_SECRET_KAY_FOR_DATABASE_CONNECTION
  cache_secret: true
  cache_key: CUSTOMIZED_CACHE_KEY
  cache_expires_in: 360
```

**IMPORTANT**
When using cache to store the connection and save requests to aws secret, it is really important to be sure that no one can access your cache storage from outside the application, to not expose your database connection informations to outside world.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/zygotecnologia/activerecord-aws-secret-connector.
This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the (Contributor Covenant)[http://contributor-covenant.org/] code of conduct.

## License

The gem is available as open source under the terms of the (MIT License)[https://opensource.org/licenses/MIT].

## TODO:

- [ ] Adds tests
- [ ] Adds configuration to connect to a different aws region from the default application aws region

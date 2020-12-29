module ActiveRecord
  module ConnectionAdapters
    class ConnectionPool
      private

      DEFAULT_DATABASE_SECRET_CACHE_KEY = "DATABASE_SECRET_FOR_#{Rails.env.upcase}"

      # Overrides default new_connection method from active record
      # to verify if database.yml has an aws_secret key
      # It uses the aws_secret from database.yml to get
      # all database connection informations from aws secret
      # and possibly cache it to use it later easier
      # when this key is present.
      # Otherwise, just work as normal connection for activerecord default feature
      def new_connection
        config = spec.config

        if spec.config.key? :aws_secret
          database_info = database_config_with_cache if spec.config.try(:cache_secret)

          database_info ||= database_config_from_secret

          config.merge!(
            host: database_info["host"],
            port: database_info["port"],
            database: database_info["dbname"],
            username: database_info["username"],
            password: database_info["password"]
          )
        end

        Base.send(spec.adapter_method, config).tap do |conn|
          conn.check_version
        end
      end

      # Returns database config from cache if it is there, otherwise
      # gets it from aws secret, stores it on cache and returns
      #
      # @return { "host" => "SOME_VALUE", "port" => "SOME_VALUE", "dbname" => "SOME_VALUE", "username" => "SOME_VALUE", "password" => "SOME_VALUE" }
      def database_config_with_cache
        Rails.cache.fetch(database_secret_cache_key, expire_in: database_secret_cache_expiration) do
          database_config_from_secret
        end
      end

      # Returns database config from secret directly
      #
      # @return { "host" => "SOME_VALUE", "port" => "SOME_VALUE", "dbname" => "SOME_VALUE", "username" => "SOME_VALUE", "password" => "SOME_VALUE" }
      def database_config_from_secret
        client = Aws::SecretsManager::Client.new

        JSON.parse(client.get_secret_value(secret_id: spec.config[:aws_secret]).secret_string)
      end

      def database_secret_cache_key
        spec.config.try(:cache_key).presence || DEFAULT_DATABASE_SECRET_CACHE_KEY
      end

      def database_secret_cache_expiration
        (spec.config.try(:cache_expires_in).presence || 60).minutes
      end
    end
  end
end

module TurnoutProxy

  class HostChooser
    def initialize(connection, options = {})
      @connection = connection
      @file_checker = options.fetch(:file_checker) { File }

      @default = validate_host(options[:default])
      @alternate = validate_host(options[:alternate])

      @lock_file = options[:lock_file]

      choose_destination_server!
    end

    def on_data(data)
      data
    end

    private

    def choose_destination_server!
      name, proxy_options = if use_alternate?
        [:alternate, @alternate]
      else
        [:default, @default]
      end
      @connection.server(name, proxy_options.merge(:relay_client => true, :relay_server => true))
    end

    def use_alternate?
      @file_checker.exists?(@lock_file)
    end

    def validate_host(host_config)
      if host_config.nil? || String(host_config[:host]).empty?  || host_config[:port].nil?
        raise ArgumentError, "Bad host config, both host and port must be present."
      end
      host_config
    end
  end

end

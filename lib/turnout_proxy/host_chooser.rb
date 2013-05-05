module TurnoutProxy

  class HostChooser
    attr_accessor :file_checker

    def initialize(connection, options = {})
      @connection = connection
      @file_checker = File

      @default = validate_host(options[:default])
      @alternate = validate_host(options[:alternate])

      @lock_file = options[:lock_file]
    end

    def on_data(data)
      use_alternate? ? @connection.server(:alternate, @alternate) : @connection.server(:default, @default)
      data
    end

    private

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

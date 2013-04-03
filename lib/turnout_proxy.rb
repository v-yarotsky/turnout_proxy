require 'em-proxy'
require 'turnout_proxy/host_chooser'

module TurnoutProxy
  version_file = File.expand_path('../VERSION', File.dirname(__FILE__))
  VERSION = File.read(version_file).freeze

  def self.run(options = {})
    Proxy.start(options) do |conn|
      callbacks = HostChooser.new(conn, options)
      conn.on_data &callbacks.method(:on_data)
    end
  end
end


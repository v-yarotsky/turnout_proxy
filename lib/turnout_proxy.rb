require 'em-proxy'
require 'turnout_proxy/host_chooser'
require 'turnout_proxy/version'

module TurnoutProxy
  def self.run(options = {})
    Proxy.start(options) do |conn|
      callbacks = HostChooser.new(conn, options)
      conn.on_data &callbacks.method(:on_data)
    end
  end
end


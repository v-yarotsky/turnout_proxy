require 'rubygems'
require 'bundler/setup'
require 'posix/spawn'
require 'eventmachine'

class HelloServer
  include POSIX::Spawn

  def initialize(port, message)
    @pid = spawn("ruby #{__FILE__} #{port} #{message}")
    at_exit { die }
  end

  def pid
    @pid
  end

  def die
    Process.kill(:SIGQUIT, pid)
  end
end

def HelloServer(response)
  Module.new do
   define_method :receive_data do |data|
     send_data "HTTP/1.1 200 OK\r\nContent-Length: #{response.length}\r\n\r\n#{response}"
     close_connection_after_writing
   end
  end
end

if $0 == __FILE__
  EventMachine.run do
    EventMachine.start_server "0.0.0.0", ARGV[0].to_i, HelloServer(ARGV[1] || "OK")
  end
end

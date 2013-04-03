require 'test_helper'
require 'fileutils'
require 'net/http'
require 'posix/spawn'
require 'support/hello_server'
require 'turnout_proxy'

class TestTurnoutProxy < TurnoutProxyTestCase
  include POSIX::Spawn
  include TurnoutProxy

  TEST_LOCK_FILE = PROJECT_ROOT.join("lock")

  def setup
    @@servers ||= begin
      HelloServer.new(8083, "S1")
      HelloServer.new(8084, "S2")
    end
    FileUtils.rm_rf TEST_LOCK_FILE
  end

  def teardown
    FileUtils.rm_rf TEST_LOCK_FILE
  end

  def with_running_proxy
    router = PROJECT_ROOT.join("bin/turnout_proxy")
    pid = spawn("ruby -Ilib #{router} --default-port=8083 --alternate-port=8084 --lock-file=#{TEST_LOCK_FILE}")
    sleep 0.5
    yield
    sleep 0.5
  ensure
    Process.kill(:SIGQUIT, pid)
  end

  test "proxies to default server when lock does not exist" do
    called = false
    with_running_proxy do
      called = Net::HTTP.get(URI("http://127.0.0.1:5678")) == "S1"
    end
    assert called, "Expected to proxy to server on 8083"
  end

  test "proxies to alternate server when lock file does exist" do
    FileUtils.touch TEST_LOCK_FILE
    called = false
    with_running_proxy do
      called = Net::HTTP.get(URI("http://127.0.0.1:5678")) == "S2"
    end
    assert called, "Expected to proxy to server on 8084"
  end

end

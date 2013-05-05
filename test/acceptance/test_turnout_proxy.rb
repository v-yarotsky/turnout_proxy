require 'test_helper'
require 'fileutils'
require 'net/http'
require 'support/travis_spawn'
require 'support/hello_server'
require 'turnout_proxy'

class TestTurnoutProxy < TurnoutProxyTestCase
  include TravisSpawn
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

  def with_running_proxy(default_port = 8083, alternate_port = 8084)
    router = PROJECT_ROOT.join("bin/turnout_proxy")
    pid = spawn("ruby -Ilib #{router} --default-port=#{default_port} --alternate-port=#{alternate_port} --lock-file=#{TEST_LOCK_FILE}")
    sleep 0.5
    yield pid
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

  test "doesn't fail if destination server isn't responding" do
    with_running_proxy(8085) do |pid|
      Net::HTTP.get(URI("http://127.0.0.1:5678")) rescue nil
      assert_equal 0, `kill -0 #{pid}`.chomp.to_i
    end
  end

end


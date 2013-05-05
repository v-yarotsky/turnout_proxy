require 'test_helper'
require 'turnout_proxy/host_chooser'

class TestHostChooser < TurnoutProxyTestCase
  include TurnoutProxy

  class FakeConnection
    attr_reader :forwards

    def initialize
      @forwards = []
    end

    def server(*data)
      @forwards << data
    end
  end

  class FakeFile
    def exists!(file)
      @existing_file = file
    end

    def exists?(file)
      !!@existing_file
    end
  end

  def setup
    @connection = FakeConnection.new
    @file_checker = FakeFile.new
  end

  ALTERNATE_CONFIG = { :host => "127.0.0.1", :port => 19999, :relay_client => true, :relay_server => true }
  DEFAULT_CONFIG = { :host => "127.0.0.1", :port => 9012, :relay_client => true, :relay_server => true }

  def host_chooser
    host_chooser = HostChooser.new(@connection,
                                   :default => DEFAULT_CONFIG,
                                   :alternate => ALTERNATE_CONFIG,
                                   :file_checker => @file_checker)
    host_chooser
  end

  test "it routes to developer tunnel if lock file exists" do
    @file_checker.exists!("/tmp/betsoft.lock")
    host_chooser.on_data("Hello")
    assert_equal [[:alternate, ALTERNATE_CONFIG]], @connection.forwards
  end

  test "it routes to staging if lock file does not exist" do
    host_chooser.on_data("Hello")
    assert_equal [[:default, DEFAULT_CONFIG]], @connection.forwards
  end

  test "it raises if alternate host not specified" do
    assert_raise(ArgumentError) do
      HostChooser.new(@connection, :default => DEFAULT_CONFIG)
    end

    assert_raise(ArgumentError) do
      HostChooser.new(@connection, :default => DEFAULT_CONFIG, :alternate => {})
    end
  end
end


require 'test/unit'
require 'pathname'

$:.unshift File.expand_path('../../lib', __FILE__)

class TurnoutProxyTestCase < Test::Unit::TestCase
  PROJECT_ROOT = Pathname.new(File.expand_path("../../", __FILE__))

  def default_test
    # Make Test::Unit happy...
  end

  def self.test(name, &block)
    raise ArgumentError, "Example name can't be empty" if String(name).empty?
    define_method "test #{name}", &block
  end
end


module TurnoutProxy
  version_file = File.expand_path('../../../VERSION', __FILE__)
  VERSION = File.read(version_file).freeze
end

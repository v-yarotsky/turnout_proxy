# -*- encoding: utf-8 -*-

$:.unshift File.expand_path('../lib/', __FILE__)

require 'turnout_proxy'
require 'date'

Gem::Specification.new do |s|
  s.name = "turnout_proxy"
  s.summary = "Proxy server which allows to switch between two destinations using lock file"

  s.version = TurnoutProxy::VERSION.dup
  s.authors = ["Vladimir Yarotsky"]
  s.date = Date.today.to_s
  s.email = "vladimir.yarotksy@gmail.com"
  s.homepage = "http://github.com/v-yarotsky/turnout_proxy"
  s.licenses = ["MIT"]

  s.rubygems_version = "1.8.21"
  s.required_rubygems_version = ">= 1.3.6"
  s.specification_version = 3

  s.files            = `git ls-files`.split($/)
  s.executables      = s.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  s.test_files       = s.files.grep(%r{^(test)/})
  s.require_paths    = ["lib"]
  s.extra_rdoc_files = %w[LICENSE.txt README.md]

  s.add_dependency("em-proxy", "~> 0.1")

  s.add_development_dependency("rake")
  s.add_development_dependency("posix-spawn")
end



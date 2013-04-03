require 'rubygems'
require 'bundler/setup'
require 'rake'
require 'rake/testtask'
require 'rake/clean'
require 'bundler/gem_tasks'

begin
  Bundler.setup
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

CLOBBER.include('doc/**', 'pkg/**', 'coverage/**')

Rake::TestTask.new do |t|
  t.libs << "test"
  t.pattern = "test/{lib,acceptance}/**/test*.rb"
end

task :default => [:test]


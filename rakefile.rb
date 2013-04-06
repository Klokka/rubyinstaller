#!/usr/bin/env ruby

# Ensure '.' is in the LOAD_PATH in Ruby 1.9.2
$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__))

# Load Rake
begin
  require 'rake'
rescue LoadError
  require 'rubygems'
  require 'rake'
end

# Added download task from buildr
require 'rake/downloadtask'
require 'rake/extracttask'

# RubyInstaller configuration data
require 'config/ruby_installer'

Dir.glob("#{RubyInstaller::ROOT}/recipes/**/*.rake").sort.each do |ext|
  puts "Loading #{File.basename(ext)}" if Rake.application.options.trace
  load ext
end

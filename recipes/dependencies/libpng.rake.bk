require 'rake'
require 'rake/clean'

namespace(:dependencies) do
  namespace(:libpng) do
    standard_download_and_extract RubyInstaller::LibPng
  end
end

task :download  => ['dependencies:libpng:download']
task :extract   => ['dependencies:libpng:extract']

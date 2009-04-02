require 'rake'
require 'rake/clean'

namespace :compiler do
  namespace :mingw do
    package = RubyInstaller::MinGW
    standard_download_and_extract package
  end
end

task :download  => ['compiler:mingw:download']
task :extract   => ['compiler:mingw:extract']

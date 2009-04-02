require 'rake'
require 'rake/clean'

namespace(:dependencies) do
  namespace(:git) do
    package = RubyInstaller::Git
    standard_download_and_extract package
  end
end

task :download  => ['dependencies:git:download']
task :extract => ['dependencies:git:extract']

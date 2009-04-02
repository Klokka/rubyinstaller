require 'rake'
require 'rake/clean'

namespace(:dependencies) do
  namespace(:winhttp) do
    package = RubyInstaller::Winhttp
    standard_download_and_extract package
  end
end

task :download  => ['dependencies:winhttp:download']
task :extract   => ['dependencies:winhttp:extract']

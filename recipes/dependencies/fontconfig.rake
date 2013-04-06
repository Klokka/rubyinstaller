require 'rake'
require 'rake/clean'

namespace(:dependencies) do
  namespace(:fontconfig) do
    standard_download_and_extract RubyInstaller::FontConfig
  end
end

task :download  => ['dependencies:fontconfig:download']
task :extract   => ['dependencies:fontconfig:extract']

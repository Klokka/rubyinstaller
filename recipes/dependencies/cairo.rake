require 'rake'
require 'rake/clean'

namespace(:dependencies) do
  namespace(:cairo) do
    standard_download_and_extract RubyInstaller::Cairo
  end
end

task :download  => ['dependencies:cairo:download']
task :extract   => ['dependencies:cairo:extract']

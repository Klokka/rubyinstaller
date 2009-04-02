require 'rake'
require 'rake/clean'

namespace(:dependencies) do
  namespace(:libzlib) do
    package = RubyInstaller::Zlib
    standard_download_and_extract package
  end
end

task :download  => ['dependencies:libzlib:download']
task :extract   => ['dependencies:libzlib:extract']

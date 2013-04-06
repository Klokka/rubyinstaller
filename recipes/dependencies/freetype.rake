require 'rake'
require 'rake/clean'

namespace(:dependencies) do
  namespace(:freetype) do
    standard_download_and_extract RubyInstaller::Freetype
  end
end

task :download  => ['dependencies:freetype:download']
task :extract   => ['dependencies:freetype:extract']

require 'rake'
require 'rake/clean'

namespace(:dependencies) do
  namespace(:expat) do
    standard_download_and_extract RubyInstaller::Expat
  end
end

task :download  => ['dependencies:expat:download']
task :extract   => ['dependencies:expat:extract']

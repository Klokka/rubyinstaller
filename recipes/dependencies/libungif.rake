require 'rake'
require 'rake/clean'

namespace(:dependencies) do
  namespace(:libungif) do
    standard_download_and_extract RubyInstaller::LibUnGif
  end
end

task :download  => ['dependencies:libungif:download']
task :extract   => ['dependencies:libungif:extract']

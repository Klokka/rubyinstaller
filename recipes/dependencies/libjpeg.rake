require 'rake'
require 'rake/clean'

namespace(:dependencies) do
  namespace(:libjpeg) do
    standard_download_and_extract RubyInstaller::LibJpeg
  end
end

task :download  => ['dependencies:libjpeg:download']
task :extract   => ['dependencies:libjpeg:extract']

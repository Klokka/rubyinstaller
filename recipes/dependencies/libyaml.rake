require 'rake'
require 'rake/clean'

namespace(:dependencies) do
  namespace(:libyaml) do
    standard_download_and_extract RubyInstaller::LibYaml
  end
end

task :download  => ['dependencies:libyaml:download']
task :extract   => ['dependencies:libyaml:extract']

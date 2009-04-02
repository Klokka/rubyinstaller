require 'rake'
require 'rake/clean'

namespace(:dependencies) do
  namespace(:pango) do
    standard_download_and_extract RubyInstaller::Pango
  end
end

task :download  => ['dependencies:pango:download']
task :extract   => ['dependencies:pango:extract']

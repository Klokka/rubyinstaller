require 'rake'
require 'rake/clean'

namespace(:dependencies) do
  namespace(:glib) do
    standard_download_and_extract RubyInstaller::Glib
  end
end

task :download  => ['dependencies:glib:download']
task :extract   => ['dependencies:glib:extract']

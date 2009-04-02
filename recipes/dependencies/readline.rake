require 'rake'
require 'rake/clean'

namespace(:dependencies) do
  namespace(:readline) do
    package = RubyInstaller::Readline
    standard_download_and_extract package
  end
end

unless ENV['NOREADLINE']
  task :download  => ['dependencies:readline:download']
  task :extract   => ['dependencies:readline:extract']
end

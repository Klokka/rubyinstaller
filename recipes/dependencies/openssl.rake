require 'rake'
require 'rake/clean'

namespace(:dependencies) do
  namespace(:openssl) do
    standard_download_and_extract RubyInstaller::OpenSsl
  end
end

task :download  => ['dependencies:openssl:download']
task :extract   => ['dependencies:openssl:extract']

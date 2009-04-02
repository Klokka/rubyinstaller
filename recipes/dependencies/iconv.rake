require 'rake'
require 'rake/clean'

namespace(:dependencies) do
  namespace(:iconv) do
    package = RubyInstaller::Iconv
    standard_download_and_extract RubyInstaller::Gdbm
    
    task :prepare => [package.target] do
      # win_iconv needs some adjustments.
      # remove *.txt
      # remove src folder
      # leave zlib1.dll inside bin ;-)
      cd File.join(RubyInstaller::ROOT, package.target) do
        rm_rf "src"
        Dir.glob("*.txt").each do |path|
          rm_f path
        end
      end
    end
  end
end

task :download  => ['dependencies:iconv:download']
task :extract   => ['dependencies:iconv:extract']
task :prepare   => ['dependencies:iconv:prepare']

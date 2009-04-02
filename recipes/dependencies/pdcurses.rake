require 'rake'
require 'rake/clean'

namespace(:dependencies) do
  namespace(:pdcurses) do
    package = RubyInstaller::PdCurses
    standard_download_and_extract package
    
    task :prepare => [package.target] do
      # pdcurses needs some relocation of files
      cd File.join(RubyInstaller::ROOT, package.target) do
        mv 'pdcurses.dll', 'bin'
        mv [ 'panel.h', 'curses.h' ], 'include'
        mv 'pdcurses.lib', 'lib/libcurses.a'
      end
    end
  end
end

task :download  => ['dependencies:pdcurses:download']
task :extract   => ['dependencies:pdcurses:extract']
task :prepare   => ['dependencies:pdcurses:prepare']

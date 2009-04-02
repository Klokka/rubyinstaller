require 'rake'
require 'rake/clean'

namespace(:dependencies) do
  namespace(:sqlite3) do
    package = RubyInstaller::Sqlite3
    standard_download_and_extract package
    mingw_root = File.join RubyInstaller::ROOT, RubyInstaller::MinGW.target
    
    task :prepare => [package.target] do
      cp(
        File.join(package.target, 'sqlite3.dll'),
        File.join(mingw_root, 'bin')
      )
      cp(
        File.join(package.target, 'sqlite3.h'),
        File.join(mingw_root, 'include')
      )
    end
    
    task :link_dll => [:prepare] do
      p "dlltool --dllname #{package.target}/sqlite3.dll --def #{package.target}/sqlite3.def --output-lib #{mingw_root}/lib/sqlite3.lib"
      msys_sh "dlltool --dllname #{package.target}/sqlite3.dll --def #{package.target}/sqlite3.def --output-lib #{mingw_root}/lib/sqlite3.lib"
    end
  end
end

task :download  => ['dependencies:sqlite3:download']
task :extract   => ['dependencies:sqlite3:extract']
task :prepare => ['dependencies:sqlite3:prepare', 'dependencies:sqlite3:link_dll']

require 'rake'
require 'rake/clean'

namespace(:dependencies) do
  namespace(:sqlite3) do
    package = RubyInstaller::Sqlite3
    directory package.target
    CLEAN.include(package.target)
    
    # Put files for the :download task
    package.files.each do |f|
      file_source = "#{package.url}/#{f}"
      file_target = "downloads/#{f}"
      download file_target => file_source
      
      # depend on downloads directory
      file file_target => "downloads"
      
      # download task need these files as pre-requisites
      task :download => file_target
    end

    # Prepare the :sandbox, it requires the :download task
    task :extract => [:extract_utils, :download, package.target] do
      # grab the files from the download task
      files = Rake::Task['dependencies:sqlite3:download'].prerequisites

      files.each { |f|
        extract(File.join(RubyInstaller::ROOT, f), package.target)
      }
    end
    
    task :prepare => [package.target] do
      cp File.join(package.target, 'sqlite3.dll'), File.join(RubyInstaller::MinGW.target, 'bin')
      cp File.join(package.target, 'sqlite3.h'), File.join(RubyInstaller::MinGW.target, 'include')
    end
    
    task :link_dll => [:prepare] do
      msys_sh "dlltool --dllname #{package.target}/sqlite3.dll --def #{package.target}/sqlite3.def --output-lib #{RubyInstaller::MinGW.target}/lib/sqlite3.lib"
    end
  end
end

task :download  => ['dependencies:sqlite3:download']
task :extract   => ['dependencies:sqlite3:extract']
task :prepare => ['dependencies:sqlite3:prepare', 'dependencies:sqlite3:link_dll']

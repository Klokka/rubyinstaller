require 'rake'
require 'rake/clean'

namespace(:dependencies) do
  namespace(:gdbm) do
    package = RubyInstaller::Gdbm
    standard_download_and_extract package
    
    task :prepare => [package.target] do
      # gdbm needs some adjustments.
      # move gdbm-dll.h from source to include
      cd File.join(RubyInstaller::ROOT, package.target) do
        files = Dir.glob(File.join('src', 'gdbm', '*', 'gdbm-*-src', 'gdbm-dll.h'))
        fail "Multiple gdbm-dll.h files found." unless files.size == 1
        gdbm_dll_h = files[0]
        cp gdbm_dll_h, 'include'
      end
    end
  end
end

task :download  => ['dependencies:gdbm:download']
task :extract   => ['dependencies:gdbm:extract']
task :prepare   => ['dependencies:gdbm:prepare']

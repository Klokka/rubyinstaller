require 'rake'
require 'rake/clean'

namespace(:dependencies) do
  namespace(:port_audio) do
    package = RubyInstaller::PortAudio
    extracted_files_target = File.join package.target, 'portaudio'
    
    directory extracted_files_target
    directory package.install_target
    CLEAN.include(package.target)
    CLEAN.include(package.install_target)
    
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
      files = Rake::Task['dependencies:port_audio:download'].prerequisites

      files.each { |f|
        extract(File.join(RubyInstaller::ROOT, f), package.target)
      }
    end

    makefile = File.join(extracted_files_target, 'Makefile')
    configurescript = File.join(extracted_files_target, 'configure')

    file makefile => [ package.target, configurescript ] do
      cd extracted_files_target do
        msys_sh "configure --prefix=#{File.join(RubyInstaller::ROOT, package.install_target)}"
      end
    end

    task :configure => makefile    
    
    task :compile => makefile do
      cd extracted_files_target do
        msys_sh "make"
      end
    end

    task :make_install => [package.install_target] do
      cd extracted_files_target do
        msys_sh "make install"
      end
    end

    task :install => [package.install_target] do
      full_install_target = File.expand_path(File.join(RubyInstaller::ROOT, package.install_target))
      
      # perform make install
      cd extracted_files_target do
        msys_sh "make install"
      end      
    end
  end
end

task :download  => ['dependencies:port_audio:download']
task :extract   => ['dependencies:port_audio:extract']
task :source_dependency_configure => ['dependencies:port_audio:configure']
task :source_dependency_compile   => ['dependencies:port_audio:compile']
task :source_dependency_install   => ['dependencies:port_audio:make_install']

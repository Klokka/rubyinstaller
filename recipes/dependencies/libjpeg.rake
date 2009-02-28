require 'rake'
require 'rake/clean'

namespace(:dependencies) do
  namespace(:libjpeg) do
    package = RubyInstaller::LibJpeg
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
      files = Rake::Task['dependencies:libjpeg:download'].prerequisites

      files.each { |f|
        extract(File.join(RubyInstaller::ROOT, f), package.target)
      }
    end
  end
end

task :download  => ['dependencies:libjpeg:download']
task :extract   => ['dependencies:libjpeg:extract']

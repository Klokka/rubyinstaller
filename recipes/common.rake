require 'rake'
require 'rake/clean'

sandbox = File.join RubyInstaller::ROOT, 'sandbox'
downloads = File.join RubyInstaller::ROOT, 'downloads'

# default cleanup
CLOBBER.include sandbox
CLOBBER.include downloads

# define common tasks
directory downloads
directory sandbox

def standard_download_and_extract(package)
  target = File.join RubyInstaller::ROOT, package.target
  directory target
  CLEAN.include target

  standard_download package
  standard_extract package
end

def file_paths(package)
  package.files.map{|f| File.join RubyInstaller::DOWNLOADS, f}
end

def standard_download(package)
  package_file_uris = package.files.map{|f| URI.parse "#{package.url}/#{f}"}
  file_paths(package).each_with_index do |f, i|
    uri = package_file_uris[i]
    file_create(f){p "downloading #{uri} to #{f}"; uri.download(f, {:verbose => true})}
    file f => RubyInstaller::DOWNLOADS
    task :download => f
  end
end

def standard_extract(package)
    target = File.join RubyInstaller::ROOT, package.target
    # Prepare the :sandbox, it requires the :download task
    task :extract => [:extract_utils, :download, target] do
      p "extracting #{package}"
      file_paths(package).each{|f| extract f, target}
    end
end

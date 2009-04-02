require 'rake/contrib/unzip'

namespace(:extract_utils) do
  package = RubyInstaller::ExtractUtils
  standard_download package

  directory package.target
  CLEAN.include(package.target)
  
  task :extract_utils => [:download, package.target] do
    package.files.each do |f|
      path = File.join RubyInstaller::DOWNLOADS, f
      Zip.fake_unzip(path, /\.exe|\.dll$/, package.target)
    end
  end
end

task :download => ['extract_utils:download']
task :extract_utils => ['extract_utils:extract_utils']

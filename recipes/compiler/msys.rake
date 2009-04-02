require 'rake'
require 'rake/clean'

namespace(:compiler) do
  namespace(:msys) do
    package = RubyInstaller::MSYS
    target = File.join RubyInstaller::ROOT, package.target
    standard_download_and_extract package
    
    # prepares the msys environment to be used
    task :prepare do
      # relocate all content from usr to / since
      # msys is hardcoded to mount /usr and cannot be overwriten
      from_folder = File.join(package.target, "usr")
      Dir.glob("#{from_folder}/*").reject { |f| f =~ /local$/ }.each do |f|
        cp_r f, package.target
      end
      Dir.glob("#{from_folder}/local/*").each do |f|
        cp_r f, package.target
      end
      rm_rf from_folder
      
      # create the fstab file, mount /mingw to sandbox/mingw
      # mount also /usr/local to sandbox/msys/usr
      File.open(File.join(target, "etc", "fstab"), 'w') do |f|
        f.puts "#{File.join RubyInstaller::ROOT, RubyInstaller::MinGW.target} /mingw"
      end
    
      #remove the chdir to $HOME in the /etc/profile
      profile = File.join(target, "etc", "profile")
      
      contents = File.read(profile).gsub(/cd \"\$HOME\"/) do |match|
        "# commented to allow calling from current directory\n##{match}"
      end
      File.open(profile, 'w') { |f| f.write(contents) }
    end
    
    def msys_sh(*args)
      cmd = args.join(' ')
      sh "\"#{File.join(RubyInstaller::ROOT, RubyInstaller::MSYS.target, "bin")}/bash.exe\" --login -i -c \"#{cmd}\""
    end
    
    def msys_system(*args)
      cmd = args.join(' ')
      system "\"#{File.join(RubyInstaller::ROOT, RubyInstaller::MSYS.target, "bin")}/bash.exe\" --login -i -c \"#{cmd}\""
    end
    
  end
end

task :download  => ['compiler:msys:download']
task :extract   => ['compiler:msys:extract']
task :prepare   => ['compiler:msys:prepare']

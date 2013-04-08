require 'rake'
require 'rake/clean'

namespace(:interpreter) do
  namespace(:lumi) do
    package = RubyInstaller::Lumi
    git_cmd = File.join(RubyInstaller::ROOT, RubyInstaller::Git.target, 'bin', 'git')
    
    task :checkout do
      # Empty function
    end
    
    task :compile do
      # pass git path to rake
      cd File.join(RubyInstaller::ROOT, package.target) do
        msys_sh "rake --trace GIT=#{git_cmd}"
      end
    end
  end
end

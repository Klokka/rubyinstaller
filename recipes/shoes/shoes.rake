require 'rake'
require 'rake/clean'

namespace(:interpreter) do
  namespace(:shoes) do
    package = RubyInstaller::Shoes
    git_cmd = File.join(RubyInstaller::ROOT, RubyInstaller::Git.target, 'bin', 'git')
    
    task :checkout do
      # If is there already a checkout, update instead of checkout"
      if File.exist?(File.join(RubyInstaller::ROOT, package.checkout_target, '.git'))
        cd File.join(RubyInstaller::ROOT, package.checkout_target) do
          sh "#{git_cmd} pull"
        end
      else
        cd RubyInstaller::ROOT do
          sh "#{git_cmd} clone #{package.checkout} #{package.checkout_target}"
        end
      end
    end
    
    task :compile do
      cd File.join(RubyInstaller::ROOT, package.target) do
        msys_sh "rake --trace GIT=#{git_cmd}"
      end
    end
  end
end

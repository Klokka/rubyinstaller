require 'rake'
require 'rake/clean'

namespace(:interpreter) do
  namespace(:ruby18) do
    package = RubyInstaller::Ruby18
    standard_download_and_extract package
    target = File.join RubyInstaller::ROOT, package.target
    build_target = File.join RubyInstaller::ROOT, package.build_target
    install_target = File.join RubyInstaller::ROOT, package.install_target

    directory target
    directory build_target
    CLEAN.include(target)
    CLEAN.include(build_target)

    task :prepare => [build_target] do
      cd RubyInstaller::ROOT do
        cp_r(Dir.glob('resources/icons/*.ico'), build_target, :verbose => true)
      end
    end

    makefile = File.join(build_target, 'Makefile')
    configurescript = File.join(target, 'configure')

    file configurescript => [ target ] do
      cd target do
        msys_sh "autoconf"
      end
    end

    file makefile => [ build_target, configurescript ] do
      cd build_target do
        msys_sh "../ruby_1_8/configure --prefix=\"#{install_target}\" #{package.configure_options.join(' ')}"
      end
    end

    task :configure => makefile
    
    task :compile => makefile do
      cd build_target do
        msys_sh "make"
      end
    end

    task :make_install => [install_target] do
      cd build_target do
        msys_sh "make install"
      end
    end

    task :install => [install_target] do
      full_install_target = File.expand_path(install_target)
      
      # perform make install
      cd build_target do
        msys_sh "make install"
      end
      
      # verbatim copy the binaries listed in package.dependencies
      package.dependencies.each do |dep|
        Dir.glob("#{RubyInstaller::MinGW.target}/**/#{dep}").each do |path|
          cp path, File.join(install_target, "bin")
        end
      end
      
      # copy original scripts from ruby_1_8 to install_target
      Dir.glob("#{target}/bin/*").each do |path|
        cp path, File.join(install_target, "bin")
      end

      # remove path reference to sandbox (after install!!!)
      rbconfig = File.join(install_target, 'lib/ruby/1.8/i386-mingw32/rbconfig.rb')
      contents = File.read(rbconfig).gsub(/#{Regexp.escape(full_install_target)}/) { |match| "" }
      File.open(rbconfig, 'w') { |f| f.write(contents) }
    end

    # makes the installed ruby the first in the path and use if for the tests!
    task :check do
      new_ruby = File.join(install_target, "bin").gsub(File::SEPARATOR, File::ALT_SEPARATOR)
      ENV['PATH'] = "#{new_ruby};#{ENV['PATH']}"
      cd build_target do
        msys_sh "make check"
      end
    end

    task :manifest do
      manifest = File.open(File.join(build_target, "manifest"), 'w')
      cd install_target do
        Dir.glob("**/*").each do |f|
          manifest.puts(f) unless File.directory?(f)
        end
      end
      manifest.close
    end

    task :irb do
      cd File.join(install_target, 'bin') do
        sh "irb"
      end
    end
  end
end

if ENV['RUBY18']
  if ENV['CHECKOUT']
    task :download  => ['interpreter:ruby18:checkout']
  else
    task :download  => ['interpreter:ruby18:download']
  end
  task :extract   => ['interpreter:ruby18:extract']
  task :prepare   => ['interpreter:ruby18:prepare']
  task :source_dependency_configure => ['interpreter:ruby18:configure']
  task :source_dependency_compile   => ['interpreter:ruby18:compile']
  task :source_dependency_install   => ['interpreter:ruby18:make_install']
  task :check     => ['interpreter:ruby18:check']
  task :irb       => ['interpreter:ruby18:irb']
end
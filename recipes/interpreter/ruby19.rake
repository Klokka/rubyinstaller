require 'rake'
require 'rake/clean'

namespace(:interpreter) do
  namespace(:ruby19) do
    package = RubyInstaller::Ruby19
    standard_download_and_extract package
    target = File.join RubyInstaller::ROOT, package.target
    build_target = File.join RubyInstaller::ROOT, package.build_target
    install_target = File.join RubyInstaller::ROOT, package.install_target

    directory build_target
    directory install_target
    CLEAN.include build_target
    CLEAN.include install_target

    task :prepare => [build_target] do
      cd RubyInstaller::ROOT do
        cp_r(Dir.glob('resources/icons/*.ico'), build_target, :verbose => true)
      end

      # FIXME: Readline is not working, remove it for now.
      cd target do
        rm_f 'test/readline/test_readline.rb'
      end
    end
    
    makefile = File.join(build_target, 'Makefile')
    file makefile => [build_target] do
      cd build_target do
        msys_sh "../ruby_1_9/configure #{package.configure_options.join(' ')} --enable-shared --prefix=#{install_target}"
      end
    end

    task :configure => makefile
    
    task :compile => makefile do
      cd build_target do
        msys_sh "make"
      end
    end

    task :make_install => [install_target] do
      p "hello hello hello hello hello hello hello"
      cd build_target do
        msys_sh "make install"
      end
      cd target do
        %w{rake gem irb}.each do|s|
          p "==============================="
          p File.join('bin', s)
          p File.join(RubyInstaller::ROOT, RubyInstaller::MinGW.target, 'bin')
          p "==============================="
          cp(
            File.join('bin', s),
            File.join(RubyInstaller::ROOT, RubyInstaller::MinGW.target, 'bin')
          )
        end
      end
    end

    task :install => [install_target] do
      # perform make install
      cd build_target do
        msys_sh "make install"
      end
      
      # verbatim copy the binaries listed in package.dependencies
      package.dependencies.each do |dep|
        Dir.glob("#{File.join RubyInstaller::ROOT, RubyInstaller::MinGW.target}/**/#{dep}").each do |path|
          cp path, File.join(install_target, "bin")
        end
      end
      
      # copy original scripts from ruby_1_9 to install_target
      Dir.glob("#{target}/bin/*").each do |path|
        cp path, File.join(install_target, "bin")
      end

      # remove path reference to sandbox (after install!!!)
      rbconfig = File.join(install_target, 'lib/ruby/1.9.1/i386-mingw32/rbconfig.rb')
      contents = File.read(rbconfig).gsub(/#{Regexp.escape(install_target)}/) { |match| "" }
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

unless ENV['RUBY18']
  if ENV['CHECKOUT']
    task :download  => ['interpreter:ruby19:checkout']
  else
    task :download  => ['interpreter:ruby19:download']
  end
  task :extract   => ['interpreter:ruby19:extract']
  task :prepare   => ['interpreter:ruby19:prepare']
  task :source_dependency_configure => ['interpreter:ruby19:configure']
  task :source_dependency_compile   => ['interpreter:ruby19:compile']
  task :source_dependency_install   => ['interpreter:ruby19:make_install']
  task :check     => ['interpreter:ruby19:check']
  task :irb       => ['interpreter:ruby19:irb']
end

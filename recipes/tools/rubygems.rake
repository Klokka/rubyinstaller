require 'rake'
require 'rake/clean'

namespace(:tools) do
  namespace(:rubygems) do
    package = RubyInstaller::RubyGems
    standard_download_and_extract package
    interpreter = RubyInstaller::Ruby18
    
    target = File.join RubyInstaller::ROOT, package.target
    install_target = File.join RubyInstaller::ROOT, package.install_target
    interpreter_target = File.join RubyInstaller::ROOT, interpreter.install_target
    directory install_target
    CLEAN.include(install_target)
    
    task :install => [target, install_target, interpreter_target] do
      new_ruby = File.join(interpreter_target, "bin").gsub(File::SEPARATOR, File::ALT_SEPARATOR)
      ENV['PATH'] = "#{new_ruby};#{ENV['PATH']}"
      ENV.delete("RUBYOPT")
      cd target do
        sh "ruby setup.rb install #{package.configure_options.join(' ')} --destdir=#{install_target}"
      end

      # now fixes all the stub batch files form bin
      Dir.glob("{#{interpreter_target},#{install_target}}/bin/*.bat").each do |bat|
        script = File.basename(bat).gsub(File.extname(bat), '')
        File.open(bat, 'w') do |f|
          f.puts <<-TEXT
@ECHO OFF
IF NOT "%~f0" == "~f0" GOTO :WinNT
@"ruby.exe" "#{File.join("C:/Ruby/bin", script)}" %1 %2 %3 %4 %5 %6 %7 %8 %9
GOTO :EOF
:WinNT
@"ruby.exe" "%~dpn0" %*
TEXT
        end
      end

      # and now, fixes the shebang lines for the scripts
      bang_line = "#!#{File.expand_path(File.join(interpreter_target, 'bin', 'ruby.exe'))}"
      Dir.glob("#{install_target}/bin/*").each do |script|
        # only process true scripts!!! (extensionless)
        if File.extname(script) == ""
          contents = File.read(script).gsub(/#{Regexp.escape(bang_line)}/) do |match|
            "#!/usr/bin/env ruby"
          end
          File.open(script, 'w') { |f| f.write(contents) }
        end
      end

      # now relocate lib into lib/ruby/site_ruby (to conform default installation).
      # Dir.chdir(package.install_target) do
      #   mv 'lib', '1.8'
      #   mkdir_p 'lib/ruby/site_ruby'
      #   mv '1.8', 'lib/ruby/site_ruby'
      # end
    end
  end
end

if ENV['RUBY18']
  if ENV['CHECKOUT']
    task :download  => ['tools:rubygems:checkout']
  else
    task :download  => ['tools:rubygems:download']
  end
  task :extract   => ['tools:rubygems:extract']
  task :install   => ['tools:rubygems:install']
end

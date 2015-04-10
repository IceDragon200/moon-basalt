require 'basalt/config'
require 'fileutils'
require 'yaml'

module Basalt
  module Project
    def self.generate_default_config
      {
        'modules_path' => 'modules'
      }
    end

    def self.init(options = {})
      config = Basalt::Config.get

      FileUtils::Verbose.mkdir_p('.basalt')
      unless File.exist?('.basalt/config.yml')
        File.write('.basalt/config.yml', generate_default_config.to_yaml)
      end
      FileUtils::Verbose.mkdir_p('build')
      FileUtils::Verbose.touch('.basalt/config.yml')
      FileUtils::Verbose.mkdir_p('resources')
      FileUtils::Verbose.mkdir_p('scripts')
      FileUtils::Verbose.touch('scripts/load.rb')

      if options.fetch(:use_modules, false)
        FileUtils::Verbose.mkdir_p('modules')
        FileUtils::Verbose.mkdir_p('core')
        unless File.exist?('core/load.rb')
          File.open('core/load.rb', 'w') do |f|
            f.puts '## generated by basalt'
            f.puts '## Load your modules here'
            f.puts '#require \'core/modules\''
          end
        end
        unless File.exist?('core/modules.rb')
          File.open('core/modules.rb', 'w') do |f|
            f.puts '$: << \'modules\''
            f.puts '## install the core module via: basalt modules install core'
            f.puts 'require \'modules/core/load\''
          end
        end
      else
        # Legacy
        unless Dir.exist?('core')
          FileUtils::Verbose.ln_s(File.join(config['moon_path'], 'core'), 'core')
        end
      end

      if options.fetch(:use_git, false)
        File.open('.gitignore', 'w') do |file|
          file.puts '# Auto Generated by basalt'
          file.puts 'sync.shaders.x'
          file.puts '/build'
          file.puts '/resources'
        end
      end

      File.open('play', 'w') do |file|
        file.puts('#!/usr/bin/env bash')
        file.puts('moon-player')
      end
      FileUtils::Verbose.chmod('+x', 'play')

      shaders_path = File.join(config['moon_path'], 'assets/shaders/')

      File.open('sync.shaders.x', 'w') do |file|
        file.puts(%Q(#!/usr/bin/env bash))
        file.puts(%Q(# generated by basalt))
        file.puts(%Q(# This script will copy the shaders from moon into your project))
        file.puts(%Q(rm -rvf "resources/shaders"))
        file.puts(%Q(mkdir -vp "resources/shaders"))
        file.puts(%Q(cp -vrf "#{shaders_path}" "resources/"))
      end
      FileUtils::Verbose.chmod('+x', 'sync.shaders.x')

      system('bash ./sync.shaders.x')
    end
  end
end

require "basalt/config"
require "fileutils"
require "yaml"

module Basalt
  module Project
    def self.init(options={})
      config = Basalt::Config.get

      FileUtils::Verbose.mkdir_p('.basalt')
      unless File.exist?('.basalt/config.yml')
        File.write('.basalt/config.yml', { 'modules_path' => 'modules' }.to_yaml)
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
          File.open('core/load.rb') do |f|
            f.puts '## generated by basalt'
            f.puts '## Load your modules here'
            f.puts '$: << \'modules\''
            f.puts '## install the core module via: basalt modules install core'
            f.puts '#require \'modules/core/load\''
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
          file.puts '/.basalt'
          file.puts '/build'
          file.puts '/resources'
        end
      end

      unless File.exist?('game')
        FileUtils::Verbose.ln_s(File.join(config['moon_path'], 'bin/host/game'), 'game')
      end

      File.open('play', 'w') do |file|
        file.puts('#!/usr/bin/env bash')
        file.puts('./game')
      end
      FileUtils::Verbose.chmod('+x', 'play')

      shaders_path = File.join(config['moon_path'], 'shaders/')

      File.open('sync.resources.x', 'w') do |file|
        file.puts(%Q(#!/usr/bin/env bash))
        file.puts(%Q(# generated by basalt))
        file.puts(%Q(# This script will copy the shaders from moon into your project))
        file.puts(%Q(rm -rvf "resources/shaders"))
        file.puts(%Q(mkdir -vp "resources/shaders"))
        file.puts(%Q(cp -vrf "#{shaders_path}" "resources/"))
      end
      FileUtils::Verbose.chmod('+x', 'sync.resources.x')

      `./sync.resources.x`
    end
  end
end

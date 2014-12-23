require 'yaml'

module Basalt
  module ProjectConfig
    def self.configname
      '.basalt/config.yml'
    end

    def self.get
      @config ||= begin
        YAML.load_file(configname)
      end
    end

    def self.exist?
      File.exist?(configname)
    end
  end
end

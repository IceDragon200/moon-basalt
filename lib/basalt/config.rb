require 'yaml'

module Basalt
  module Config
    def self.get
      @config ||= begin
        configname = File.join(Dir.home, '.basaltrc')
        YAML.load_file(configname)
      end
    end
  end
end

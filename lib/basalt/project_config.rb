require "yaml"

module Basalt
  module ProjectConfig
    def self.get
      @config ||= begin
        configname = ".basalt/config.yml"
        YAML.load_file(configname)
      end
    end
  end
end

require 'ostruct'
require 'yaml'

module Basalt
  module Config
    class Base
      attr_reader :filename

      def initialize(filename)
        @filename = filename
      end

      def save
        File.write(filename, get.to_h.to_yaml)
      end

      def load
        OpenStruct.new(YAML.load_file(filename))
      end

      def reload
        @config = nil
        get
      end

      def get
        @config ||= load
      end

      def exist?
        File.exist?(filename)
      end

      def [](key)
        get[key]
      end
    end
  end
end

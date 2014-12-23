module Basalt
  # BasaltMods is the parser for Basaltmods files used by basalt to install
  # modules
  module BasaltMods
    class BasaltModule
      attr_accessor :name
      attr_accessor :options

      def initialize(name, options)
        @name = name
        @options = options
      end

      def to_h
        {
          name: @name,
          options: @options
        }
      end
    end

    class Context
      attr_accessor :install_dir
      attr_accessor :modules

      def initialize
        @install_dir = nil
        @modules = []
      end

      def set(options)
        options.each do |k, v|
          self.send("#{k}=", v)
        end
      end

      def mod(name, options = {})
        @modules << BasaltModule.new(name, options)
      end

      def _eval_file(filename)
        str = File.read(filename)
        instance_eval(str, filename, 1)
      end

      def to_h
        {
          install_dir: @install_dir,
          modules: @modules.map(&:to_h)
        }
      end

      def self.load_file(filename)
        new.tap { |e| e._eval_file(filename) }
      end
    end

    def self.default_filename
      'Basaltmods'
    end

    def self.exist?
      File.exist?(default_filename)
    end

    def self.load_file(filename)
      Context.load_file(filename)
    end

    def self.load_project_file
      load_file(default_filename)
    end
  end
end

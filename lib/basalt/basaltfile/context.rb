module Basalt
  class Basaltfile
    class Context
      # @return [String]  target directory to install packages to
      attr_accessor :pkgdir
      # @return [String]  default installation method for packages
      # Can either be 'ref' or 'copy'
      attr_accessor :install_method
      # @return [Array<Basalt::Basaltfile::Package>]
      attr_accessor :packages

      def initialize(pkgdir = nil)
        @pkgdir = ENV['BASALT_PKGDIR'] || pkgdir || 'packages'
        @install_method = nil
        @packages = []
      end

      def set(options)
        options.each do |k, v|
          self.send("#{k}=", v)
        end
      end

      def pkg(name, options = {})
        opts = options.dup
        opts[:package] ||= name
        @packages << Package.new(name, opts)
      end

      def eval_data(data, filename = self.class.name)
        instance_eval(data, filename, 1)
      end

      def eval_file(filename)
        str = File.read(filename)
        eval_data(str, filename)
      end

      def to_h
        {
          pkgdir: @pkgdir,
          packages: @packages.map(&:to_h)
        }
      end

      def self.load_file(filename)
        new.tap { |e| e.eval_file(filename) }
      end
    end
  end
end

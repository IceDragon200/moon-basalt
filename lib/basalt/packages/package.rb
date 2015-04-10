require 'active_support/core_ext/string/inflections'
require 'ostruct'
require 'yaml'

module Basalt
  class Packages
    class Package
      PACKAGE_SPEC_FILENAME = 'pkg.yml'

      # Where is this package located?
      # @return [String]
      attr_accessor :path
      # the machine/package friendly name of the package, should include no spaces.
      # @return [String]
      attr_accessor :pkgname

      # @param [String] path
      # @param [String] pkgname
      # @param [Hash<String, Object>] data
      def initialize(path, pkgname, data)
        @path = path
        @pkgname = pkgname
        @data = data
      end

      # Human friendly name of the package.
      #
      # @return [String]
      def name
        @data['name']
      end

      # Who made this package?
      #
      # @return [String]
      def author
        @data['author'] || '<UNKNOWN>'
      end

      # A description of the package, a detailed one.
      #
      # @return [String]
      def description
        @data['description'] || ''
      end

      # A summary of the package, just a quick note on what it provides.
      # This will default to the description if there is not summary.
      #
      # @return [String]
      def summary
        @data['summary'] || description
      end

      # Name of the file to inject in the packages/load.rb
      # This can be nil to skip the injection.
      #
      # @return [nil, String]
      def entry_point
        @data['entry_point'] || @data['require']
      end

      # A list of packages that this package depends on.
      #
      # @return [Array<String>]
      def deps
        @data['deps'] || []
      end

      # A list of packages that this package will conflict with.
      #
      # @return [Array<String>]
      def conflicts
        @data['conflicts'] || []
      end

      # @return [String]
      def entry_point_contents
        return '' unless entry_point
        e = File.join @path, entry_point
        c = "### package(.yml): #{@pkgname}/#{entry_point}\n"
        if File.exist?(e)
          c << File.read(e)
        else
          abort "#{name} stated that its :require was '#{e}', however the file was not found."
        end
        c << "\n" unless c.end_with?("\n")
        c
      end

      # Location of the pkgspec file (normally a pkg.yml)
      #
      # @return [String]
      def pkgspec_path
        File.join @path, PACKAGE_SPEC_FILENAME
      end

      # Used for saving the current pkgspec data
      #
      # @return [self]
      def save
        File.write pkgspec_path, @data.to_h.to_yaml
        self
      end

      # Loads the pkgspec data
      #
      # @return [self]
      def load
        @data = OpenStruct.new YAML.load_file(pkgspec_path)
        self
      end

      # Loads an existing package
      #
      # @return [Package]
      def self.load(path, pkgname)
        new(path, pkgname, nil).load
      end

      # Creates a new unsaved package.
      #
      # @return [Package]
      def self.create(path, pkgname)
        new(path, pkgname,
          name: pkgname.titlecase,
          author: ENV['USER'],
          summary: '',
          description: '',
          entry_point: '_basalt.rb',
          deps: [],
          conflicts: []
        )
      end
    end
  end
end

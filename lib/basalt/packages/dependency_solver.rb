require 'colorize'

module Basalt
  class Packages
    class DependecySolver
      # @return [Array<Package>]
      attr_accessor :packages

      # @param [Array<Package>] packages
      def initialize(packages)
        @packages = packages
        @package_map = packages.each_with_object({}) { |m, h| h[m.pkgname] = m }
      end

      # @param [String] str
      # @param [Hash<Symbol, Object>] options
      private def handle_err(str, options)
        prefix = "DependecySolver: "
        if options[:err_warn]
          STDERR.puts prefix + str.light_yellow
        else
          abort prefix + str.light_red
        end
      end

      # @param [Package] pkg
      # @param [Integer] depth
      # @param [Hash<Symbol, Object>] options
      def get_deps(pkg, depth = 0, options = {})
        abort 'Dependecy depth too deep (passed 100)'.light_red if depth > 100
        pkg.conflicts.each do |depname|
          if @package_map.key?(depname)
            handle_err "#{pkg.pkgname} conflicts with #{depname}.", options
          end
        end
        pkg.deps.map do |depname|
          dep = @package_map.fetch(depname) do
            handle_err "#{pkg.pkgname} depends on #{depname}.", options
          end
          get_deps(dep, depth + 1, options)
        end.flatten + [pkg]
      end

      # @param [Hash] options
      def solve(options = {})
        packages.map { |pkg| get_deps(pkg, 0, options) }.flatten.uniq
      end

      # @param [Array<Package>] packages
      # @param [Hash<Symbol, Object>] options
      def self.solve(packages, options)
        new(packages).solve(options)
      end
    end
  end
end

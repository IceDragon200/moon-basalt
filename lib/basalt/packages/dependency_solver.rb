require 'colorize'

module Basalt #:nodoc:
  class Packages #:nodoc:
    class DependecySolver
      # @return [Array<Package>]
      attr_accessor :packages
      attr_accessor :package_map

      def initialize(packages)
        @packages = packages
        @package_map = packages.each_with_object({}) { |m, h| h[m.refname] = m }
      end

      def get_deps(pkg, depth = 0, options = {})
        abort 'Dependecy depth too deep (passed 100)'.light_red if depth > 100
        pkg.deps.map do |depname|
          dep = @package_map.fetch(depname) { abort "Dependecy #{depname} not in list".light_red }
          get_deps(dep, depth + 1, options)
        end.flatten + [pkg]
      end

      def solve(options = {})
        packages.map { |pkg| get_deps(pkg, 0, options) }.flatten.uniq
      end

      def self.solve(packages, options)
        new(packages).solve(options)
      end
    end
  end
end

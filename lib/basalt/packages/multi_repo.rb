require 'basalt/packages/repo'
require 'basalt/packages/package_assert'

module Basalt
  class Packages
    # Allows the searching of multiple repos as if it was one repo
    class MultiRepo
      include PackageAssert

      # @return [Array<Repo>]
      attr_accessor :repos

      def initialize
        @repos = []
      end

      def package_exists?(name)
        @repos.any? { |repo| repo.package_exists?(name) }
      end

      alias :exists? :package_exists?

      def installed?(name)
        exists?(name)
      end

      # @return [Array<Package>]
      def installed
        @repos.map(&:installed).flatten
      end

      # @param [String] name
      # @return [Package, nil]
      def get_package(name)
        @repos.each do |repo|
          pkg = repo.get_package(name)
          return pkg if pkg
        end
        nil
      end

      # @param [String] name
      # @return [Package]
      def find(name, options = {})
        pkg = get_package(name)
        fail Repo::PackageMissing.new name unless pkg
        pkg
      end
    end
  end
end

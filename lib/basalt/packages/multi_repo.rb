require 'basalt/packages/repo'

module Basalt #:nodoc:
  class Packages #:nodoc:
    # Allows the searching of multiple repos as if it was one repo
    class MultiRepo
      # @return [Array<Repo>]
      attr_accessor :repos

      def initialize
        @repos = []
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
      def find(name)
        pkg = get_package(name)
        fail Repo::PackageMissing.new name unless pkg
        return pkg
      end
    end
  end
end

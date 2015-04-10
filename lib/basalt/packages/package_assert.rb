module Basalt
  # Mixin for checking if a package exists, or not
  # Add a package_exists? to the including class/module.
  module PackageAssert
    class PackageError < RuntimeError
    end

    class PackageMissing < PackageError
      def initialize(name)
        super "package #{name} does not exist!"
      end
    end

    class PackageExists < PackageError
      def initialize(name)
        super "package #{name} exists!"
      end
    end

    # Ensures that a package exists, else it raise an error
    #
    # @param [String] name
    def ensure_package(name, opts = {})
      unless package_exists?(name)
        fail PackageMissing.new(name) unless opts[:quiet]
        return false
      end
      true
    end

    # Ensures that a package does not exist, else it raise an error
    #
    # @param [String] name
    def ensure_no_package(name, opts = {})
      if package_exists?(name)
        fail PackageExists.new(name) unless opts[:quiet]
        return false
      end
      true
    end
  end
end

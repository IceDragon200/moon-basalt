require 'basalt/packages/package'
require 'colorize'
require 'fileutils'
require 'ostruct'
require 'yaml'

module Basalt #:nodoc:
  class Packages #:nodoc:
    class Repo
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

      class ReadonlyRepo < RuntimeError
        def initialize
          super 'this repo is read only!'
        end
      end

      # parent repo to look for packages to install from
      # @return [Repo]
      attr_accessor :srcrepo
      # @return [OpenStruct]
      attr_accessor :config
      # @return [Boolean]
      attr_accessor :readonly

      def initialize(config)
        @srcrepo = self
        @config = config
        @packages = {}
        @readonly = true
      end

      # favour the given options.install_method / config.install_method / default
      def install_method_pref(options)
        options[:install_method] || @config.install_method || 'ref'
      end

      # @return [String]
      def pkgdir
        @config.pkgdir
      end

      # @return [String]
      def package_path(name)
        fail 'Empty package name' unless name && !name.empty?
        File.join pkgdir, name
      end

      # @return [Boolean]
      def exists?(name)
        Dir.exist?(package_path(name))
      end

      # @return [Boolean]
      def installed?(name)
        exists?(name)
      end

      # Ensures that a repo can be modified, otherwise it raises an error
      private def ensure_writeable
        fail ReadonlyRepo if @readonly
      end

      # Ensures that a package exists, else it raise an error
      # @param [String] name
      private def ensure_package(name, opts = {})
        unless exists?(name)
          fail PackageMissing.new(name) unless opts[:quiet]
          return false
        end
        true
      end

      # Ensures that a package does not exist, else it raise an error
      # @param [String] name
      private def ensure_no_package(name, opts = {})
        if exists?(name)
          fail PackageExists.new(name) unless opts[:quiet]
          return false
        end
        true
      end

      # @param [String] name
      # @return [Package]
      private def load_package(name)
        pkgd = package_path(name)
        pkgfile = File.join(pkgd, Package::FILENAME)
        # is this a package, or just a directory?
        if File.exist?(pkgfile)
          Package.load(pkgd, name)
        else
          nil
        end
      end

      # Loads and returns a package by name
      # @param [String] name
      # @return [Package, nil]
      def get_package(name)
        @packages[name] ||= load_package(name)
      end

      # @param [Package] package
      private def install_package(package, options = {})
        FileUtils.mkdir_p(pkgdir)
        if install_method_pref(options) == 'copy'
          FileUtils.cp_r(package.path, package_path(package.pkgname))
        else
          FileUtils.ln_sf(package.path, package_path(package.pkgname))
        end
      end

      # @param [String] name
      private def remove_package(name, options = {})
        FileUtils.rm_rf package_path(name)
      end

      # @param [Package] package
      private def update_package(package, options = {})
        remove_package(package.pkgname, options)
        install_package(@srcrepo.find(package.pkgname), options)
      end

      # @param [String] name
      private def sync_package(name, options = {})
        if exists?(name)
          update_package get_package(name), options
        else
          remove_package name, options
          install_package name, options
        end
      end

      # locate a package by name in the system repo
      # @param [String] name
      # @return [Package]
      def find(name, options = {})
        pkg = @srcrepo.get_package(name)
        fail PackageMissing.new name unless pkg
        pkg
      end

      # Retrieves a list of all installed packages
      # @return [Array<Package>]
      def installed
        result = []
        Dir.glob "#{pkgdir}/*" do |n|
          pkg = get_package(File.basename(n))
          result << pkg if pkg
        end
        result
      end

      # print details from a package
      # @param [Package] package
      # @param [Hash<Symbol, Object>] options
      def print_package(package, options = {})
        state = options[:state]
        pkgname = "%-020s" % package.pkgname
        case state
        when :exists
          pkgname = pkgname.colorize(:light_blue)
        when :install, :new, :update
          pkgname = pkgname.colorize(:light_green)
        when :remove
          pkgname = pkgname.colorize(:light_red)
        when :damaged, :missing
          pkgname = pkgname.colorize(:light_yellow)
        end
        fmt = if options[:verbose]
          "(%<path>s) %<pkgname>s :: %<name>s - %<summary>s"
        else
          "\t%<pkgname>s :: %<name>s - %<summary>s"
        end
        data = {
          path: package.path,
          pkgname: pkgname.bold,
          name: package.name.light_magenta,
          summary: package.summary
        }
        puts fmt % data
      end

      # @param [Array<Package>] list
      def print_package_list(list, options)
        list.sort_by(&:pkgname).each do |package|
          print_package package, options
        end
      end

      # Create a new package
      # @param [String] name
      def new(name, options = {})
        ensure_writeable
        ensure_no_package(name)
        pkgdir = package_path(name)
        FileUtils.mkdir_p(pkgdir)
        pkg = Package.create(pkgdir, name)
        pkg.save
        print_package pkg, options.merge(state: :new)
      end

      # install package from system repo
      # @param [String] name
      def install(name, options = {})
        ensure_writeable
        if ensure_no_package name, quiet: true
          pkg = @srcrepo.find(name)
          install_package pkg, options
          print_package pkg, options.merge(state: :install)
        else
          pkg = get_package(name)
          print_package pkg, options.merge(state: :exists)
        end
      end

      # force remove a package from project
      # @param [String] name
      def remove(name, options = {})
        ensure_writeable
        remove_package name
      end

      # uninstall a package from project
      # @param [String] name
      def uninstall(name, options = {})
        ensure_writeable
        if ensure_package name, quiet: true
          pkg = get_package(name)
          remove_package name
          print_package pkg, options.merge(state: :remove)
        end
      end

      # update an existing package to repo one
      # @param [String] name
      def update(name, options = {})
        ensure_writeable
        if ensure_package name, quiet: true
          pkg = get_package(name)
          update_package pkg, options
          print_package pkg, options.merge(state: :update)
        else
          install name, options
        end
      end

      # update an existing repo, or remove and reinstall a damaged or missing
      # package
      # @param [String] name
      def sync(name, options = {})
        ensure_writeable
        sync_package(name, options)
        print_package get_package(name), options.merge(state: :sync)
      end

      # prints data from a package in the system repo
      # @param [String] name
      def show(name, options = {})
        print_package @srcrepo.find(name, options), options
      end

      # lists all available packages in system repo
      # @param [String] name
      def list_available(options = {})
        print_package_list @srcrepo.installed, options
      end

      # lists all packages installed or to be installed
      # @param [String] name
      def list_installed(options = {})
        print_package_list installed, options
      end

      # lists all packages
      # @param [String] name
      def list(options = {})
        @srcrepo.installed.sort_by(&:pkgname).each do |package|
          state = installed?(package.pkgname) ? :exists : nil
          print_package package, options.merge(state: state)
        end
      end
    end
  end
end

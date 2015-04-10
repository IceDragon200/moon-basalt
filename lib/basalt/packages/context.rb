require 'basalt/packages/dependency_solver'
require 'basalt/packages/repo'
require 'basalt/packages/multi_repo'
require 'basalt/packages/system_repo'
require 'ostruct'

module Basalt
  class Packages
    class Context
      attr_accessor :repoconfig
      attr_reader :repo

      def initialize(config, repoconfig)
        @config = config
        @sys_repo = Basalt::Packages::Repo.system_repo(@config)
        @repoconfig = repoconfig
        @repo = Repo.new(@repoconfig)
        @repo.readonly = false
        @repo.srcrepo = @sys_repo
      end

      def context_options
        {
          pkgdir: @repoconfig.pkgdir,
          install_method: @repoconfig.install_method
        }
      end

      def options_patch(opts)
        context_options.merge(opts)
      end

      def new(name, options = {})
        @repo.new(name, options_patch(options))
      end

      def install(name, options = {})
        @repo.install(name, options_patch(options))
      end

      def uninstall(name, options = {})
        @repo.uninstall(name, options_patch(options))
      end

      def sync(name, options = {})
        @repo.sync(name, options_patch(options))
      end

      def update(name, options = {})
        @repo.update(name, options_patch(options))
      end

      def list(options = {})
        @repo.list(options_patch(options))
      end

      def list_installed(options = {})
        @repo.list_installed(options_patch(options))
      end

      def list_available(options = {})
        @repo.list_available(options_patch(options))
      end
    end
  end
end

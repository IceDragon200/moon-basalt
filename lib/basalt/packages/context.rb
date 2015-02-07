require 'basalt/packages/dependency_solver'
require 'basalt/packages/package_header'
require 'basalt/packages/repo'
require 'basalt/packages/multi_repo'
require 'basalt/packages/system_repo'
require 'ostruct'

module Basalt #:nodoc:
  class Packages #:nodoc:
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

      def new(name)
        @repo.new(name)
      end

      def install(name)
        @repo.install(name)
      end

      def uninstall(name)
        @repo.uninstall(name)
      end

      def sync(name)
        @repo.sync(name)
      end

      def update(name)
        @repo.update(name)
      end

      def list
        @repo.list
      end

      def list_installed
        @repo.list_installed
      end

      def list_available
        @repo.list_available
      end
    end
  end
end

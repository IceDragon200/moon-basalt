require 'basalt/basaltfile/package_def'
require 'basalt/basaltfile/context'

module Basalt
  class Basaltfile
    # @param [String] filename
    def initialize(filename = nil)
      @filename = filename || ENV['BASALTFILE'] || 'Basaltfile'
      @context = Context.new
      @context.eval_file(@filename)
    end

    # @return [String]
    def pkgdir
      @context.pkgdir
    end

    # @return [String]
    def install_method
      @context.install_method
    end

    # @return [Array<PackageDef>]
    def packages
      @context.packages
    end
  end
end

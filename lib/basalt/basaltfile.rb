require 'basalt/basaltfile/package'
require 'basalt/basaltfile/context'

module Basalt #:nodoc:
  class Basaltfile
    def initialize(fn = nil)
      @filename = fn || ENV['BASALTFILE'] || 'Basaltfile'
      @context = Context.new
      @context.eval_file(@filename)
    end

    def pkgdir
      @context.pkgdir
    end

    def packages
      @context.packages
    end
  end
end

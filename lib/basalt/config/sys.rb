require 'basalt/config/base'

module Basalt #:nodoc:
  module Config #:nodoc:
    class Sys < Base
      def initialize
        super ENV['BASALT_SYS_CONFIG'] || File.join(Dir.home, '.basaltrc')
      end
    end
  end
end

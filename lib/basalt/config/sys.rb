require 'basalt/config/base'

module Basalt #:nodoc:
  module Config #:nodoc:
    class Sys < Base
      def initialize
        super File.join(Dir.home, ENV['BASALT_SYS_CONFIG'] || '.basaltrc')
      end
    end
  end
end

require 'basalt/config/base'

module Basalt
  module Config
    class Sys < Base
      def initialize
        super ENV['BASALT_SYS_CONFIG'] || File.join(Dir.home, '.basaltrc')
      end
    end
  end
end

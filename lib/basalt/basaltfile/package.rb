module Basalt
  class Basaltfile
    #
    class Package
      attr_accessor :name
      attr_accessor :options

      def initialize(name, options)
        @name = name
        @options = options
      end

      def to_h
        {
          name: @name,
          options: @options
        }
      end
    end
  end
end

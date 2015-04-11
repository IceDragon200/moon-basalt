module Basalt
  class Basaltfile
    # A package def represents a pkg command in a Basaltfile
    class PackageDef
      # @!attribute name
      #   @return [String]
      attr_accessor :name
      # @!attribute options
      #   @return [Hash<Symbol, Object>]
      attr_accessor :options

      # @param [String] name
      # @param [Hash] options
      def initialize(name, options = {})
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
